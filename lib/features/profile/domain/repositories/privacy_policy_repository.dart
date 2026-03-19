/// Contract for privacy policy storage.
abstract class PrivacyPolicyRepository {
  Future<String> getPrivacyPolicy();

  Future<void> savePrivacyPolicy(String content);
}
