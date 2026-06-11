// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: privacy_policy_repository_impl.dart
// المسار: features/profile/data/repositories/privacy_policy_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • PrivacyPolicyRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/repositories/privacy_policy_repository.dart';
import '../datasources/privacy_policy_remote_datasource.dart';

/// تنفيذ مستودع الخصوصية السياسة.
class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl(this._datasource);

  /// حقل: مصدر بيانات.
  final PrivacyPolicyRemoteDatasource _datasource;

  @override
  /// يجلب الخصوصية السياسة.
  Future<String> getPrivacyPolicy() => _datasource.getPrivacyPolicy();

  @override
  /// يحفظ الخصوصية السياسة.
  Future<void> savePrivacyPolicy(String content) =>
      _datasource.savePrivacyPolicy(content);
}
