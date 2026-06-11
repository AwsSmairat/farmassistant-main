// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: get_privacy_policy.dart
// المسار: features/profile/domain/usecases/get_privacy_policy.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • GetPrivacyPolicy
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../repositories/privacy_policy_repository.dart';

/// كلاس جلب الخصوصية السياسة.
class GetPrivacyPolicy {
  GetPrivacyPolicy(this._repository);

  /// حقل: مستودع.
  final PrivacyPolicyRepository _repository;

  /// دالة call.
  Future<String> call() => _repository.getPrivacyPolicy();
}
