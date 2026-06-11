// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: get_profile.dart
// المسار: features/profile/domain/usecases/get_profile.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • GetProfile
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';
import '../../../../core/error/app_exceptions.dart';
import '../entities/profile.dart';
/// كلاس جلب الملف الشخصي.
class GetProfile {
  GetProfile(this._authRepository, this._userProfileRepository);

  /// حقل: المصادقة مستودع.
  final AuthRepository _authRepository;
  /// حقل: المستخدم الملف الشخصي مستودع.
  final UserProfileRepository _userProfileRepository;

  /// دالة call.
  Future<Profile> call() async {
    final user = _authRepository.currentUser;
    if (user == null) throw Exception('يجب تسجيل الدخول');

    final uid = user.id;
    try {
      final profileData = await _userProfileRepository.getProfileByUid(uid);
      if (profileData == null) {
        /// دالة استثناء.
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
