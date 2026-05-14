/**
 * Robot codebase Cloud Functions (callable + secrets).
 * GEMINI_API_KEY: Firebase Secret in production; optional `robot/.env`
 * for local development.
 */

const path = require("path");
const admin = require("firebase-admin");
const {GoogleGenerativeAI} = require("@google/generative-ai");
const {setGlobalOptions} = require("firebase-functions");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const logger = require("firebase-functions/logger");

require("dotenv").config({path: path.join(__dirname, ".env")});

if (!admin.apps.length) {
  admin.initializeApp();
}

setGlobalOptions({maxInstances: 10});

/**
 * Firebase-managed secret; call `.value()` inside the handler.
 */
const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

const JSON_INSTRUCTION =
  "Analyze this plant image. Determine if the plant is healthy or diseased. " +
  "If diseased, identify the most likely disease and suggest treatment. " +
  "If uncertain, use a low confidence between 0 and 1. " +
  "Return only valid JSON with exactly these keys: " +
  "{\"result\":\"Healthy\" or \"Diseased\"," +
  "\"diseaseName\":\"string (empty if healthy)\"," +
  "\"confidence\":0.0,\"treatment\":\"string\",\"explanation\":\"string\"}";

/**
 * Strips optional markdown JSON fences from model output.
 * @param {string} text Raw model text.
 * @return {string} JSON string.
 */
function stripJsonFence(text) {
  let t = text.trim();
  if (t.startsWith("```")) {
    t = t.replace(/^```[a-zA-Z]*\n?/, "").replace(/```\s*$/, "");
  }
  return t.trim();
}

/**
 * @template T
 * @param {Promise<T>} promise
 * @param {number} ms
 * @param {string} label
 * @return {Promise<T>}
 */
function withTimeout(promise, ms, label) {
  return new Promise((resolve, reject) => {
    const t = setTimeout(() => {
      reject(new Error(`Timeout ${ms}ms: ${label}`));
    }, ms);
    promise.then(
        (v) => {
          clearTimeout(t);
          resolve(v);
        },
        (e) => {
          clearTimeout(t);
          reject(e);
        },
    );
  });
}

exports.analyzePlantImage = onCall(
    {
      secrets: [GEMINI_API_KEY],
      timeoutSeconds: 240,
      memory: "512MiB",
      maxInstances: 10,
    },
    async (request) => {
      const apiKey = GEMINI_API_KEY.value();
      if (!apiKey) {
        logger.error("GEMINI_API_KEY missing");
        throw new HttpsError(
            "failed-precondition",
            "GEMINI_API_KEY is not configured",
        );
      }

      if (!request.auth || !request.auth.uid) {
        throw new HttpsError("unauthenticated", "Authentication required");
      }

      const uid = request.auth.uid;
      const data = request.data || {};
      const imageUrl = typeof data.imageUrl === "string" ?
        data.imageUrl.trim() :
        "";
      const userId = typeof data.userId === "string" ?
        data.userId.trim() :
        "";
      const hasSource = typeof data.source === "string" && data.source.trim();
      const source = hasSource ? data.source.trim() : "phone_upload";

      if (!imageUrl.startsWith("http")) {
        throw new HttpsError("invalid-argument", "Invalid imageUrl");
      }
      if (userId !== uid) {
        const msg = "userId must match signed-in user";
        throw new HttpsError("invalid-argument", msg);
      }

      let imageBuffer;
      let mimeType = "image/jpeg";
      try {
        const res = await fetch(imageUrl, {
          signal: AbortSignal.timeout(40000),
        });
        if (!res.ok) {
          const statusMsg = `Could not download image (HTTP ${res.status})`;
          throw new HttpsError("invalid-argument", statusMsg);
        }
        const ct = res.headers.get("content-type") || "";
        if (ct.includes("png")) {
          mimeType = "image/png";
        } else if (ct.includes("webp")) {
          mimeType = "image/webp";
        } else if (ct.includes("heic") || ct.includes("heif")) {
          mimeType = "image/heic";
        }
        const buf = Buffer.from(await res.arrayBuffer());
        const maxBytes = 15 * 1024 * 1024;
        if (buf.length === 0) {
          throw new HttpsError("invalid-argument", "Empty image");
        }
        if (buf.length > maxBytes) {
          throw new HttpsError("invalid-argument", "Image too large");
        }
        imageBuffer = buf;
      } catch (e) {
        if (e instanceof HttpsError) throw e;
        if (e && e.name === "TimeoutError") {
          throw new HttpsError("deadline-exceeded", "Image download timed out");
        }
        if (e && e.name === "AbortError") {
          throw new HttpsError("deadline-exceeded", "Image download timed out");
        }
        logger.error("Image download failed", e);
        throw new HttpsError("invalid-argument", "Failed to download image");
      }

      const genAI = new GoogleGenerativeAI(apiKey);
      const model = genAI.getGenerativeModel({
        model: "gemini-1.5-flash",
        generationConfig: {
          responseMimeType: "application/json",
          maxOutputTokens: 512,
          temperature: 0.15,
        },
      });

      let parsed;
      try {
        const genPromise = model.generateContent([
          {inlineData: {mimeType, data: imageBuffer.toString("base64")}},
          {text: JSON_INSTRUCTION},
        ]);
        const result = await withTimeout(genPromise, 130000, "gemini-generate");
        const response = result.response;
        let text;
        try {
          text = typeof response.text === "function" ? response.text() : "";
        } catch (err) {
          logger.error("Gemini response.text failed", err);
          throw new HttpsError("internal", "AI response invalid");
        }
        if (!text || !String(text).trim()) {
          logger.error("Gemini empty text", response.promptFeedback);
          throw new HttpsError("internal", "AI response empty");
        }
        const cleaned = stripJsonFence(text);
        parsed = JSON.parse(cleaned);
      } catch (e) {
        if (e instanceof HttpsError) throw e;
        const msg = e && e.message ? String(e.message) : "";
        if (msg.includes("Timeout")) {
          throw new HttpsError("deadline-exceeded", "AI generation timed out");
        }
        logger.error("Gemini or JSON parse error", e);
        throw new HttpsError("internal", "AI response invalid");
      }

      const outResult = String(parsed.result ?? "").trim();
      if (outResult !== "Healthy" && outResult !== "Diseased") {
        throw new HttpsError("internal", "AI response invalid: result");
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
      const firestoreResult = outResult === "Healthy" ?
        "Healthy" :
        diseaseName || "Diseased";

      try {
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
      } catch (e) {
        logger.error("Firestore write failed", e);
        throw new HttpsError("internal", "Failed to save diagnosis");
      }

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
