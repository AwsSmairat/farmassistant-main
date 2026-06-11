// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: privacy_policy_repository.dart
// المسار: features/profile/domain/repositories/privacy_policy_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • PrivacyPolicyRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// واجهة مستودع الخصوصية السياسة.
abstract class PrivacyPolicyRepository {
  /// يجلب الخصوصية السياسة.
  Future<String> getPrivacyPolicy();

  /// يحفظ الخصوصية السياسة.
  Future<void> savePrivacyPolicy(String content);
}
