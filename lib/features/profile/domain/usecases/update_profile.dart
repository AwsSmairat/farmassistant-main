// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: update_profile.dart
// المسار: features/profile/domain/usecases/update_profile.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • UpdateProfile
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';
/// كلاس تحديث الملف الشخصي.
class UpdateProfile {
  UpdateProfile(this._authRepository, this._userProfileRepository);

  /// حقل: المصادقة مستودع.
  final AuthRepository _authRepository;
  /// حقل: المستخدم الملف الشخصي مستودع.
  final UserProfileRepository _userProfileRepository;

  /// دالة call.
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
