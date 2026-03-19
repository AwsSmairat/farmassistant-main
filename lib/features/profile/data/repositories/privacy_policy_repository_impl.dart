import '../../domain/repositories/privacy_policy_repository.dart';
import '../datasources/privacy_policy_remote_datasource.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl(this._datasource);

  final PrivacyPolicyRemoteDatasource _datasource;

  @override
  Future<String> getPrivacyPolicy() => _datasource.getPrivacyPolicy();

  @override
  Future<void> savePrivacyPolicy(String content) =>
      _datasource.savePrivacyPolicy(content);
}
