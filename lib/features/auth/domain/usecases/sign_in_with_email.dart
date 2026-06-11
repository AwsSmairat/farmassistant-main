// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sign_in_with_email.dart
// المسار: features/auth/domain/usecases/sign_in_with_email.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • SignInWithEmail
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// كلاس تسجيل in with البريد.
class SignInWithEmail {
  SignInWithEmail(this._repository);

  /// حقل: مستودع.
  final AuthRepository _repository;

  /// دالة call.
  Future<AuthUser> call({required String email, required String password}) {
    return _repository.signInWithEmailAndPassword(email: email, password: password);
  }
}
