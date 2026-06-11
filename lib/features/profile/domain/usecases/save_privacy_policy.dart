// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: save_privacy_policy.dart
// المسار: features/profile/domain/usecases/save_privacy_policy.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • SavePrivacyPolicy
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../repositories/privacy_policy_repository.dart';

/// كلاس حفظ الخصوصية السياسة.
class SavePrivacyPolicy {
  SavePrivacyPolicy(this._repository);

  /// حقل: مستودع.
  final PrivacyPolicyRepository _repository;

  /// دالة call.
  Future<void> call(String content) => _repository.savePrivacyPolicy(content);
}
