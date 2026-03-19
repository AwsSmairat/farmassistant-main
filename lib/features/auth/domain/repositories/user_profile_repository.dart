import '../entities/user_profile_data.dart';

/// Contract for user profile (username, phone). Implementation in data layer.
abstract class UserProfileRepository {
  /// Returns true if [username] is already used (case-insensitive).
  Future<bool> isUsernameTaken(String username);

  /// Returns true if [phone] is already used (normalized).
  Future<bool> isPhoneTaken(String phone);

  /// Returns email for the user with [username], or null if not found.
  Future<String?> getEmailByUsername(String username);

  /// Returns email for the user with [phone] (normalized), or null if not found.
  Future<String?> getEmailByPhone(String phone);

  /// Returns true if user [uid] has a profile in user_profiles.
  Future<bool> hasProfile(String uid);

  /// Returns username for user [uid], or null if no profile.
  Future<String?> getUsernameByUid(String uid);

  /// Returns full profile data for [uid], or null if no profile.
  Future<UserProfileData?> getProfileByUid(String uid);

  /// Creates profile for user [uid] with [username], [phone], [email].
  /// Fails if username/phone already taken (e.g. race).
  Future<void> createProfile({
    required String uid,
    required String username,
    required String phone,
    required String email,
  });

  /// Updates profile for [uid]. Only [username] and/or [phone] are updated.
  /// Fails if new username/phone is taken by another user.
  Future<void> updateProfile({
    required String uid,
    String? username,
    String? phone,
  });
}
