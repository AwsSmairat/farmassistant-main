import '../../domain/entities/user_profile_data.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._datasource);

  final UserProfileRemoteDatasource _datasource;

  @override
  Future<bool> isUsernameTaken(String username) =>
      _datasource.isUsernameTaken(username);

  @override
  Future<bool> isPhoneTaken(String phone) =>
      _datasource.isPhoneTaken(phone);

  @override
  Future<String?> getEmailByUsername(String username) =>
      _datasource.getEmailByUsername(username);

  @override
  Future<String?> getEmailByPhone(String phone) =>
      _datasource.getEmailByPhone(phone);

  @override
  Future<bool> hasProfile(String uid) => _datasource.hasProfile(uid);

  @override
  Future<String?> getUsernameByUid(String uid) =>
      _datasource.getUsernameByUid(uid);

  @override
  Future<UserProfileData?> getProfileByUid(String uid) =>
      _datasource.getProfileByUid(uid);

  @override
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
  Future<void> updateProfile({
    required String uid,
    String? username,
    String? phone,
  }) =>
      _datasource.updateProfile(uid: uid, username: username, phone: phone);
}
