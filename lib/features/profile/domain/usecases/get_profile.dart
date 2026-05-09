import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';
import '../../../../core/error/app_exceptions.dart';
import '../entities/profile.dart';

/// Loads the current user's profile (from auth + user_profiles).
class GetProfile {
  GetProfile(this._authRepository, this._userProfileRepository);

  final AuthRepository _authRepository;
  final UserProfileRepository _userProfileRepository;

  Future<Profile> call() async {
    final user = _authRepository.currentUser;
    if (user == null) throw Exception('يجب تسجيل الدخول');

    final uid = user.id;
    try {
      final profileData = await _userProfileRepository.getProfileByUid(uid);
      if (profileData == null) {
        throw Exception('الملف الشخصي غير موجود');
      }

      final email = profileData.email.trim().isNotEmpty
          ? profileData.email
          : (user.email ?? '');
      return Profile(
        uid: uid,
        username: profileData.username,
        phone: profileData.phone,
        email: email,
      );
    } on PermissionDeniedException {
      // If Firestore rules deny reads, show best-effort profile from auth only.
      final username = (user.displayName?.trim().isNotEmpty == true)
          ? user.displayName!.trim()
          : (user.email ?? 'مستخدم');
      return Profile(
        uid: uid,
        username: username,
        phone: '',
        email: user.email ?? '',
      );
    }
  }
}
