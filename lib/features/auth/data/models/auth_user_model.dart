// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: auth_user_model.dart
// المسار: features/auth/data/models/auth_user_model.dart
// الطبقة: data / models — نموذج بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. جزء من ميزة المصادقة وتسجيل الدخول.
//
// ماذا بداخله؟
//   • AuthUserModel
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/auth_user.dart';
/// كلاس المصادقة المستخدم نموذج.
class AuthUserModel extends AuthUser {
  /// دالة المصادقة المستخدم نموذج.
  const AuthUserModel({
    required super.id,
    super.email,
    super.displayName,
    super.photoUrl,
    super.isEmailVerified,
  });

  factory AuthUserModel.fromFirebaseUser(dynamic user) {
    if (user == null) {
      throw Exception('فشل تسجيل الدخول: لا توجد بيانات مستخدم من Firebase.');
    }
    /// حقل: raw uid.
    final dynamic rawUid = user.uid;
    /// حقل: uid.
    final String uid = rawUid is String ? rawUid : '$rawUid';
    if (uid.isEmpty) {
      throw Exception('فشل تسجيل الدخول: معرّف المستخدم غير متاح.');
    }
    return AuthUserModel(
      id: uid,
      email: user.email as String?,
      displayName: user.displayName as String?,
      photoUrl: user.photoURL as String?,
      isEmailVerified: user.emailVerified as bool? ?? false,
    );
  }
}
