// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sign_out.dart
// المسار: features/auth/domain/usecases/sign_out.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • SignOut
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../repositories/auth_repository.dart';

/// كلاس تسجيل خروج.
class SignOut {
  SignOut(this._repository);

  /// حقل: مستودع.
  final AuthRepository _repository;

  /// دالة call.
  Future<void> call() => _repository.signOut();
}
