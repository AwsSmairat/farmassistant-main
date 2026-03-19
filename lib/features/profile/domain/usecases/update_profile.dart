import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';

/// Updates the current user's profile (username and/or phone).
class UpdateProfile {
  UpdateProfile(this._authRepository, this._userProfileRepository);

  final AuthRepository _authRepository;
  final UserProfileRepository _userProfileRepository;

  Future<void> call({
    String? username,
    String? phone,
  }) async {
    final user = _authRepository.currentUser;
    if (user == null) throw Exception('يجب تسجيل الدخول');

    if (username != null && username.trim().isEmpty) {
      throw Exception('اسم المستخدم غير صالح');
    }
    if (phone != null && phone.trim().isEmpty) {
      throw Exception('رقم الهاتف غير صالح');
    }

    await _userProfileRepository.updateProfile(
      uid: user.id,
      username: username?.trim(),
      phone: phone?.trim(),
    );
  }
}
