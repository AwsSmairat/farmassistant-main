import '../../domain/entities/auth_user.dart';

/// Data model mapping from Firebase User to domain [AuthUser].
class AuthUserModel extends AuthUser {
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
    final dynamic rawUid = user.uid;
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
