import '../repositories/privacy_policy_repository.dart';

class SavePrivacyPolicy {
  SavePrivacyPolicy(this._repository);

  final PrivacyPolicyRepository _repository;

  Future<void> call(String content) => _repository.savePrivacyPolicy(content);
}
