import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_profile_repository.dart';

class CreateAccountWithEmail {
  CreateAccountWithEmail(this._authRepository, this._profileRepository);

  final AuthRepository _authRepository;
  final UserProfileRepository _profileRepository;

  /// Creates account with email/password, checks username & phone uniqueness
  /// (after creating auth user so Firestore rules allow read), sends
  /// verification email, and creates Firestore profile.
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
        throw Exception('اسم المستخدم مستخدم بالفعل');
      }
      final phoneTaken = await _profileRepository.isPhoneTaken(phone);
      if (phoneTaken) {
        await _authRepository.deleteCurrentUser();
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
