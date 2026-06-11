// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: send_password_reset.dart
// المسار: features/auth/domain/usecases/send_password_reset.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • SendPasswordReset
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../repositories/auth_repository.dart';

/// كلاس إرسال كلمة المرور إعادة تعيين.
class SendPasswordReset {
  SendPasswordReset(this._repository);

  /// حقل: مستودع.
  final AuthRepository _repository;

  /// دالة call.
  Future<void> call(String email) => _repository.sendPasswordResetEmail(email);
}
