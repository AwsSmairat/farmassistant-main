# إصلاح خطأ تسجيل الدخول بـ Google (ApiException: 10)

الخطأ `ApiException: 10` = **DEVELOPER_ERROR** — يعني أن بصمة SHA-1 للتطبيق غير مسجلة في Firebase.

## الخطوة 1: الحصول على بصمة SHA-1

افتح الطرفية (Terminal) ونفّذ أحد الأمرين:

**على macOS/Linux (مفتاح Debug الافتراضي):**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**أو من داخل مجلد المشروع (عبر Gradle):**
```bash
cd android && ./gradlew signingReport
```
ثم ابحث عن `SHA1:` تحت `Variant: debug`.

انسخ قيمة **SHA-1** (مثل: `AA:BB:CC:...`).

---

## الخطوة 2: إضافة SHA-1 في Firebase Console

1. ادخل إلى [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروع **farmassistant-54d84**
3. اضغط أيقونة **الإعدادات (⚙️)** بجانب "Project Overview" → **Project settings**
4. تحت **Your apps** اختر تطبيق **Android** (الحزمة: `com.example.farm_assistant`)
5. انزل إلى **SHA certificate fingerprints**
6. اضغط **Add fingerprint**
7. الصق قيمة **SHA-1** التي نسختها ثم احفظ

(اختياري) إن أردت استخدام **توقيع Release** لاحقاً، أضف أيضاً SHA-1 لمفتاح الـ release.

---

## الخطوة 3: إعادة تشغيل التطبيق

- أوقف التطبيق ثم شغّله من جديد: `flutter run`
- جرّب تسجيل الدخول بـ Google مرة أخرى

---

## ملاحظات

- لا حاجة لتحميل `google-services.json` من جديد بعد إضافة SHA-1؛ التعديل يكون من جانب Firebase فقط.
- إذا كنت تبني بـ **Release** أو بمفتاح توقيع آخر، أضف SHA-1 لذلك المفتاح أيضاً في نفس المكان.
