import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacyPolicyRemoteDatasource {
  PrivacyPolicyRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'app_settings';
  static const String _docId = 'privacy_policy';

  Future<String> getPrivacyPolicy() async {
    final doc = await _firestore.collection(_collection).doc(_docId).get();
    if (!doc.exists) return '';
    final data = doc.data();
    final content = data?['content'] as String?;
    return content?.trim() ?? '';
  }

  Future<void> savePrivacyPolicy(String content) async {
    await _firestore.collection(_collection).doc(_docId).set({
      'content': content.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
