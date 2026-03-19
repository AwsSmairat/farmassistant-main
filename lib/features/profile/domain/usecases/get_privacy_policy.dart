import '../repositories/privacy_policy_repository.dart';

class GetPrivacyPolicy {
  GetPrivacyPolicy(this._repository);

  final PrivacyPolicyRepository _repository;

  Future<String> call() => _repository.getPrivacyPolicy();
}
