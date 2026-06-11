// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sign_in_with_google.dart
// المسار: features/auth/domain/usecases/sign_in_with_google.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • SignInWithGoogle
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// كلاس تسجيل in with جوجل.
class SignInWithGoogle {
  SignInWithGoogle(this._repository);

  /// حقل: مستودع.
  final AuthRepository _repository;

  /// دالة call.
  Future<AuthUser> call() => _repository.signInWithGoogle();
}
