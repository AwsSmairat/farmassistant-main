// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: privacy_policy_remote_datasource.dart
// المسار: features/profile/data/datasources/privacy_policy_remote_datasource.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. الاتصال بـ Firebase أو API.
//
// ماذا بداخله؟
//   • PrivacyPolicyRemoteDatasource
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:cloud_firestore/cloud_firestore.dart';

/// مصدر بيانات الخصوصية السياسة بعيد مصدر بيانات.
class PrivacyPolicyRemoteDatasource {
  PrivacyPolicyRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// حقل: Firestore.
  final FirebaseFirestore _firestore;

  /// حقل: collection.
  static const String _collection = 'app_settings';
  /// حقل: doc id.
  static const String _docId = 'privacy_policy';

  /// يجلب الخصوصية السياسة.
  Future<String> getPrivacyPolicy() async {
    final doc = await _firestore.collection(_collection).doc(_docId).get();
    if (!doc.exists) return '';
    final data = doc.data();
    final content = data?['content'] as String?;
    return content?.trim() ?? '';
  }

  /// يحفظ الخصوصية السياسة.
  Future<void> savePrivacyPolicy(String content) async {
    await _firestore.collection(_collection).doc(_docId).set({
      'content': content.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
