// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: user_profile_repository_impl.dart
// المسار: features/auth/data/repositories/user_profile_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • UserProfileRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/user_profile_data.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_datasource.dart';

/// تنفيذ مستودع المستخدم الملف الشخصي.
class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._datasource);

  /// حقل: مصدر بيانات.
  final UserProfileRemoteDatasource _datasource;

  @override
  /// دالة is username taken.
  Future<bool> isUsernameTaken(String username) =>
      _datasource.isUsernameTaken(username);

  @override
  /// دالة is phone taken.
  Future<bool> isPhoneTaken(String phone) =>
      _datasource.isPhoneTaken(phone);

  @override
  /// يجلب البريد by username.
  Future<String?> getEmailByUsername(String username) =>
      _datasource.getEmailByUsername(username);

  @override
  /// يجلب البريد by phone.
  Future<String?> getEmailByPhone(String phone) =>
      _datasource.getEmailByPhone(phone);

  @override
  /// دالة has الملف الشخصي.
  Future<bool> hasProfile(String uid) => _datasource.hasProfile(uid);

  @override
  /// يجلب username by uid.
  Future<String?> getUsernameByUid(String uid) =>
      _datasource.getUsernameByUid(uid);

  @override
  /// يجلب الملف الشخصي by uid.
  Future<UserProfileData?> getProfileByUid(String uid) =>
      _datasource.getProfileByUid(uid);

  @override
  /// ينشئ الملف الشخصي.
  Future<void> createProfile({
    required String uid,
    required String username,
    required String phone,
    required String email,
  }) =>
      _datasource.createProfile(
        uid: uid,
        username: username,
        phone: phone,
        email: email,
      );

  @override
  /// يحدّث الملف الشخصي.
  Future<void> updateProfile({
    required String uid,
    String? username,
    String? phone,
  }) =>
      _datasource.updateProfile(uid: uid, username: username, phone: phone);
}
