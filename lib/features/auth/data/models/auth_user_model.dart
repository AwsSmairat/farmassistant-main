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
    return AuthUserModel(
      id: user.uid as String,
      email: user.email as String?,
      displayName: user.displayName as String?,
      photoUrl: user.photoURL as String?,
      isEmailVerified: user.emailVerified as bool? ?? false,
    );
  }
}
