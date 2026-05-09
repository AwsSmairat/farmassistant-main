import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/app_exceptions.dart';
import '../../domain/entities/user_profile_data.dart';

/// Firestore operations for user profiles (username, phone uniqueness).
/// Uses index collections (username_index, phone_index) with doc ID = value
/// so Transaction.get(DocumentReference) can enforce uniqueness.
class UserProfileRemoteDatasource {
  UserProfileRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collectionName = 'user_profiles';
  static const String _usernameIndexName = 'username_index';
  static const String _phoneIndexName = 'phone_index';

  final FirebaseFirestore _firestore;

  static String _normalizeUsername(String username) =>
      username.trim().toLowerCase();

  static String _normalizePhone(String phone) =>
      phone.trim().replaceAll(RegExp(r'\s'), '');

  Future<bool> isUsernameTaken(String username) async {
    try {
      final lower = _normalizeUsername(username);
      if (lower.isEmpty) return true;
      final doc = await _firestore.collection(_usernameIndexName).doc(lower).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<bool> isPhoneTaken(String phone) async {
    try {
      final normalized = _normalizePhone(phone);
      if (normalized.isEmpty) return true;
      final doc = await _firestore.collection(_phoneIndexName).doc(normalized).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<String?> getEmailByUsername(String username) async {
    try {
      final lower = _normalizeUsername(username);
      if (lower.isEmpty) return null;
      final indexDoc = await _firestore.collection(_usernameIndexName).doc(lower).get();
      if (!indexDoc.exists) return null;
      final uid = indexDoc.data()?['uid'] as String?;
      if (uid == null || uid.isEmpty) return null;
      final profileDoc = await _firestore.collection(_collectionName).doc(uid).get();
      if (!profileDoc.exists) return null;
      final email = profileDoc.data()?['email'] as String?;
      return email?.trim().isEmpty == true ? null : email?.trim();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<String?> getEmailByPhone(String phone) async {
    try {
      final normalized = _normalizePhone(phone);
      if (normalized.isEmpty) return null;
      final indexDoc = await _firestore.collection(_phoneIndexName).doc(normalized).get();
      if (!indexDoc.exists) return null;
      final uid = indexDoc.data()?['uid'] as String?;
      if (uid == null) return null;
      final profileDoc = await _firestore.collection(_collectionName).doc(uid).get();
      return profileDoc.data()?['email'] as String?;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<bool> hasProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(uid).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<String?> getUsernameByUid(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(uid).get();
      if (!doc.exists) return null;
      final username = doc.data()?['username'] as String?;
      return username?.trim().isEmpty == true ? null : username?.trim();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<UserProfileData?> getProfileByUid(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(uid).get();
      if (!doc.exists) return null;
      final data = doc.data();
      final username = (data?['username'] as String?)?.trim() ?? '';
      final phone = (data?['phone'] as String?)?.trim() ?? '';
      final email = (data?['email'] as String?)?.trim() ?? '';
      return UserProfileData(username: username, phone: phone, email: email);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<void> createProfile({
    required String uid,
    required String username,
    required String phone,
    required String email,
  }) async {
    final usernameLower = _normalizeUsername(username);
    final phoneNormalized = _normalizePhone(phone);
    if (usernameLower.isEmpty) throw Exception('اسم المستخدم غير صالح');
    if (phoneNormalized.isEmpty) throw Exception('رقم الهاتف غير صالح');

    try {
      await _firestore.runTransaction((tx) async {
      final usernameRef = _firestore.collection(_usernameIndexName).doc(usernameLower);
      final phoneRef = _firestore.collection(_phoneIndexName).doc(phoneNormalized);
      final profileRef = _firestore.collection(_collectionName).doc(uid);

      final usernameSnap = await tx.get(usernameRef);
      if (usernameSnap.exists) {
        throw Exception('اسم المستخدم مستخدم بالفعل');
      }
      final phoneSnap = await tx.get(phoneRef);
      if (phoneSnap.exists) {
        throw Exception('رقم الهاتف مستخدم بالفعل');
      }

      tx.set(usernameRef, {'uid': uid});
      tx.set(phoneRef, {'uid': uid});
      tx.set(profileRef, {
        'username': username.trim(),
        'username_lower': usernameLower,
        'phone': phone.trim(),
        'phone_normalized': phoneNormalized,
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? username,
    String? phone,
  }) async {
    try {
      final profileRef = _firestore.collection(_collectionName).doc(uid);
      final profileSnap = await profileRef.get();
      if (!profileSnap.exists) throw Exception('الملف الشخصي غير موجود');

      final data = profileSnap.data() ?? {};
      final oldUsernameLower = (data['username_lower'] as String?) ?? '';
      final oldPhoneNormalized = (data['phone_normalized'] as String?) ?? '';

      final newUsernameLower = username != null ? _normalizeUsername(username) : null;
      final newPhoneNormalized = phone != null ? _normalizePhone(phone) : null;

      if (newUsernameLower != null && newUsernameLower.isEmpty) {
        throw Exception('اسم المستخدم غير صالح');
      }
      if (newPhoneNormalized != null && newPhoneNormalized.isEmpty) {
        throw Exception('رقم الهاتف غير صالح');
      }

      final usernameChanged = newUsernameLower != null && newUsernameLower != oldUsernameLower;
      final phoneChanged = newPhoneNormalized != null && newPhoneNormalized != oldPhoneNormalized;

      if (usernameChanged) {
        final key = newUsernameLower;
        final existing = await _firestore.collection(_usernameIndexName).doc(key).get();
        if (existing.exists && ((existing.data()?['uid'] as String?) != uid)) {
          throw Exception('اسم المستخدم مستخدم بالفعل');
        }
      }
      if (phoneChanged) {
        final key = newPhoneNormalized;
        final existing = await _firestore.collection(_phoneIndexName).doc(key).get();
        if (existing.exists && ((existing.data()?['uid'] as String?) != uid)) {
          throw Exception('رقم الهاتف مستخدم بالفعل');
        }
      }

      await _firestore.runTransaction((tx) async {
        final updates = <String, dynamic>{};
        if (usernameChanged) {
          tx.delete(_firestore.collection(_usernameIndexName).doc(oldUsernameLower));
          tx.set(_firestore.collection(_usernameIndexName).doc(newUsernameLower), {'uid': uid});
          updates['username'] = username!.trim();
          updates['username_lower'] = newUsernameLower;
        }
        if (phoneChanged) {
          tx.delete(_firestore.collection(_phoneIndexName).doc(oldPhoneNormalized));
          tx.set(_firestore.collection(_phoneIndexName).doc(newPhoneNormalized), {'uid': uid});
          updates['phone'] = phone!.trim();
          updates['phone_normalized'] = newPhoneNormalized;
        }
        if (updates.isNotEmpty) {
          tx.update(profileRef, updates);
        }
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const PermissionDeniedException();
      rethrow;
    }
  }
}
