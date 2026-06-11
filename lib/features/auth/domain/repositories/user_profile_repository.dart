// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: user_profile_repository.dart
// المسار: features/auth/domain/repositories/user_profile_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • UserProfileRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/user_profile_data.dart';
/// واجهة مستودع المستخدم الملف الشخصي.
abstract class UserProfileRepository {
  /// Returns true if [username] is already used (case-insensitive).
  /// دالة is username taken.
  Future<bool> isUsernameTaken(String username);

  /// Returns true if [phone] is already used (normalized).
  /// دالة is phone taken.
  Future<bool> isPhoneTaken(String phone);

  /// Returns email for the user with [username], or null if not found.
  /// يجلب البريد by username.
  Future<String?> getEmailByUsername(String username);

  /// Returns email for the user with [phone] (normalized), or null if not found.
  /// يجلب البريد by phone.
  Future<String?> getEmailByPhone(String phone);

  /// Returns true if user [uid] has a profile in user_profiles.
  /// دالة has الملف الشخصي.
  Future<bool> hasProfile(String uid);

  /// Returns username for user [uid], or null if no profile.
  /// يجلب username by uid.
  Future<String?> getUsernameByUid(String uid);

  /// Returns full profile data for [uid], or null if no profile.
  /// يجلب الملف الشخصي by uid.
  Future<UserProfileData?> getProfileByUid(String uid);

  /// Creates profile for user [uid] with [username], [phone], [email].
  /// Fails if username/phone already taken (e.g. race).
  /// ينشئ الملف الشخصي.
  Future<void> createProfile({
    required String uid,
    required String username,
    required String phone,
    required String email,
  });

  /// Updates profile for [uid]. Only [username] and/or [phone] are updated.
  /// Fails if new username/phone is taken by another user.
  /// يحدّث الملف الشخصي.
  Future<void> updateProfile({
    required String uid,
    String? username,
    String? phone,
  });
}
