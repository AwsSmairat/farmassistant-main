/**
 * Callable: analyzePlantImage
 *
 * Env (set in Firebase / Google Cloud for the Functions runtime):
 *   GEMINI_API_KEY   — Google AI Studio key (never ship in Flutter).
 *
 * Deploy: firebase deploy --only functions
 */
import {GoogleGenerativeAI} from "@google/generative-ai";
import * as admin from "firebase-admin";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {logger} from "firebase-functions";

if (!admin.apps.length) {
  admin.initializeApp();
}

const JSON_INSTRUCTION = `Analyze this plant image. Determine if the plant is healthy or diseased. If diseased, identify the most likely disease and suggest treatment. If uncertain, use a low confidence value between 0 and 1. Return only valid JSON with exactly these keys:
{"result":"Healthy" or "Diseased","diseaseName":"string (empty if healthy)","confidence":0.0,"treatment":"string","explanation":"string"}`;

function stripJsonFence(text: string): string {
  let t = text.trim();
  if (t.startsWith("```")) {
    t = t.replace(/^```[a-zA-Z]*\n?/, "").replace(/```\s*$/, "");
  }
  return t.trim();
}

export const analyzePlantImage = onCall(
  {timeoutSeconds: 120, memory: "512MiB"},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Authentication required");
    }
    const uid = request.auth.uid;
    const data = request.data as Record<string, unknown> | undefined;
    const imageUrl = typeof data?.imageUrl === "string" ? data.imageUrl : "";
    const userId = typeof data?.userId === "string" ? data.userId : "";
    const source = typeof data?.source === "string" ? data.source : "phone_upload";

    if (!imageUrl.startsWith("http")) {
      throw new HttpsError("invalid-argument", "Invalid imageUrl");
    }
    if (userId !== uid) {
      throw new HttpsError("invalid-argument", "userId must match signed-in user");
    }

    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      logger.error("GEMINI_API_KEY is not set");
      throw new HttpsError(
        "failed-precondition",
        "GEMINI_API_KEY is not configured on the server",
      );
    }

    let imageBuffer: Buffer;
    let mimeType = "image/jpeg";
    try {
      const res = await fetch(imageUrl);
      if (!res.ok) {
        throw new HttpsError("invalid-argument", "Could not download image from URL");
      }
      const ct = res.headers.get("content-type") ?? "";
      if (ct.includes("png")) {
        mimeType = "image/png";
      } else if (ct.includes("webp")) {
        mimeType = "image/webp";
      }
      imageBuffer = Buffer.from(await res.arrayBuffer());
      const max = 15 * 1024 * 1024;
      if (imageBuffer.length > max) {
        throw new HttpsError("invalid-argument", "Image too large");
      }
    } catch (e: unknown) {
      if (e instanceof HttpsError) {
        throw e;
      }
      logger.error("Image fetch failed", e);
      throw new HttpsError("invalid-argument", "Failed to fetch image");
    }

    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
      generationConfig: {
        responseMimeType: "application/json",
      },
    });

    type AiJson = {
      result?: string;
      diseaseName?: string;
      confidence?: number;
      treatment?: string;
      explanation?: string;
    };

    let parsed: AiJson;
    try {
      const gen = await model.generateContent([
        {inlineData: {mimeType, data: imageBuffer.toString("base64")}},
        {text: JSON_INSTRUCTION},
      ]);
      const text = gen.response.text();
      const cleaned = stripJsonFence(text);
      parsed = JSON.parse(cleaned) as AiJson;
    } catch (e: unknown) {
      logger.error("Gemini / JSON parse error", e);
      throw new HttpsError("internal", "AI response invalid");
    }

    const outResult = String(parsed.result ?? "").trim();
    if (outResult !== "Healthy" && outResult !== "Diseased") {
      throw new HttpsError("internal", "AI response invalid");
    }

    const diseaseName = String(parsed.diseaseName ?? "").trim();
    let confidence = Number(parsed.confidence);
    if (!Number.isFinite(confidence)) {
      confidence = 0;
    }
    if (confidence > 1) {
      confidence = confidence / 100;
    }
    confidence = Math.max(0, Math.min(1, confidence));
    if (outResult === "Healthy" && confidence < 0.35) {
      confidence = 0.55;
    }

    const treatment = String(parsed.treatment ?? "").trim() || "—";
    const explanation = String(parsed.explanation ?? "").trim() || "—";
    const diagnosedAt = new Date().toISOString();
    const firestoreResult =
      outResult === "Healthy" ? "Healthy" : diseaseName || "Diseased";

    await admin.firestore().collection("ai_diagnosis").add({
      userId: uid,
      robotId: "external_phone_upload",
      source,
      imageUrl,
      result: firestoreResult,
      diseaseName: outResult === "Healthy" ? "" : diseaseName || "Unknown",
      confidence,
      treatment,
      explanation,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      result: outResult,
      diseaseName: outResult === "Healthy" ? "" : diseaseName,
      confidence,
      treatment,
      explanation,
      diagnosedAt,
    };
  },
);
