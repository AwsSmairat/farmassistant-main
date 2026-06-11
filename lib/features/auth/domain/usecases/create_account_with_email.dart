// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: create_account_with_email.dart
// المسار: features/auth/domain/usecases/create_account_with_email.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • CreateAccountWithEmail
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_profile_repository.dart';

/// كلاس إنشاء حساب with البريد.
class CreateAccountWithEmail {
  CreateAccountWithEmail(this._authRepository, this._profileRepository);

  /// حقل: المصادقة مستودع.
  final AuthRepository _authRepository;
  /// حقل: الملف الشخصي مستودع.
  final UserProfileRepository _profileRepository;

  /// Creates account with email/password, checks username & phone uniqueness
  /// (after creating auth user so Firestore rules allow read), sends
  /// verification email, and creates Firestore profile.
  /// دالة call.
  Future<AuthUser> call({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    final user = await _authRepository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    try {
      final usernameTaken = await _profileRepository.isUsernameTaken(username);
      if (usernameTaken) {
        await _authRepository.deleteCurrentUser();
        /// دالة استثناء.
        throw Exception('اسم المستخدم مستخدم بالفعل');
      }
      final phoneTaken = await _profileRepository.isPhoneTaken(phone);
      if (phoneTaken) {
        await _authRepository.deleteCurrentUser();
        /// دالة استثناء.
        throw Exception('رقم الهاتف مستخدم بالفعل');
      }

      await _authRepository.sendEmailVerification();

      await _profileRepository.createProfile(
        uid: user.id,
        username: username,
        phone: phone,
        email: email,
      );

      return user;
    } catch (e) {
      try {
        await _authRepository.deleteCurrentUser();
      } catch (_) {}
      rethrow;
    }
  }
}
