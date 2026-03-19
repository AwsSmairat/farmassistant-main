# مجموعات Firestore للملف الشخصي وعدم تكرار اسم المستخدم ورقم الهاتف

التطبيق يستخدم ثلاث مجموعات:

1. **user_profiles** — الملف الشخصي لكل مستخدم (معرف المستند = `uid`)
2. **username_index** — فهرس لضمان عدم تكرار اسم المستخدم (معرف المستند = اسم المستخدم بحروف صغيرة)
3. **phone_index** — فهرس لضمان عدم تكرار رقم الهاتف (معرف المستند = رقم الهاتف طبيعي)

## user_profiles

- **المعرف (doc id):** نفس `uid` المستخدم من Firebase Auth
- **الحقول:**
  - `username`, `username_lower`, `phone`, `phone_normalized`, `email`, `createdAt`

## username_index

- **المعرف (doc id):** اسم المستخدم بحروف صغيرة (مثل `johndoe`)
- **الحقول:** `uid` (معرف المستخدم)

## phone_index

- **المعرف (doc id):** رقم الهاتف بدون مسافات (مثل `0512345678`)
- **الحقول:** `uid` (معرف المستخدم)

## قواعد الأمان (Firestore Security Rules)

في Firebase Console → Firestore Database → Rules أضف قواعد تسمح بما يلي:

- قراءة/كتابة `user_profiles` للمستخدمين المسجلين فقط (أو اربط الكتابة بـ `request.auth.uid`).
- التطبيق يتحقق من عدم تكرار اسم المستخدم ورقم الهاتف **بعد** إنشاء مستخدم Firebase Auth، لذلك طلبات القراءة تتم والمستخدم مسجل دخوله.

مثال مبسط:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_profiles/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update, delete: if request.auth != null && request.auth.uid == userId;
    }
    match /username_index/{username} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null;
    }
    match /phone_index/{phone} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null;
    }
  }
}
```

للاستعلامات (where) على المجموعة تحتاج أيضاً أن يكون للمستخدم صلاحية القراءة على المجموعة (القراءة تتم من التطبيق بعد تسجيل الدخول عند إنشاء حساب جديد، إذن المستخدم يكون مسجلاً مؤقتاً عند الاستعلام عن username/phone).

## فهارس (Indexes)

الاستعلامات الحالية هي على حقل واحد فقط (`username_lower` أو `phone_normalized`) ولا تحتاج فهارس مركبة. Firestore ينشئ فهرساً تلقائياً للحقول المفردة.
