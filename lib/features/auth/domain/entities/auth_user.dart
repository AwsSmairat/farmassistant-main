// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: auth_user.dart
// المسار: features/auth/domain/entities/auth_user.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. جزء من ميزة المصادقة وتسجيل الدخول.
//
// ماذا بداخله؟
//   • AuthUser
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
/// كلاس المصادقة المستخدم.
class AuthUser extends Equatable {
  /// دالة المصادقة المستخدم.
  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  /// حقل: id.
  final String id;
  /// حقل: البريد.
  final String? email;
  /// حقل: display name.
  final String? displayName;
  /// حقل: photo url.
  final String? photoUrl;
  /// حقل: is البريد verified.
  final bool isEmailVerified;

  @override
  /// يُرجع props.
  List<Object?> get props => [id, email, displayName, photoUrl, isEmailVerified];
}
