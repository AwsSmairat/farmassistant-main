import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_profile_repository.dart';

/// Signs in with email or username + password.
/// Resolves username to email via profile then signs in with email.
class SignInWithIdentifier {
  SignInWithIdentifier(this._authRepository, this._profileRepository);

  final AuthRepository _authRepository;
  final UserProfileRepository _profileRepository;

  static bool _looksLikeEmail(String s) =>
      s.trim().contains('@') && s.trim().contains('.');

  Future<AuthUser> call({
    required String identifier,
    required String password,
  }) async {
    final trimmed = identifier.trim();
    if (trimmed.isEmpty) throw Exception('أدخل البريد الإلكتروني أو اسم المستخدم');

    String email;
    if (_looksLikeEmail(trimmed)) {
      email = trimmed;
    } else {
      final found = await _profileRepository.getEmailByUsername(trimmed);
      if (found == null) throw Exception('لا يوجد حساب مرتبط باسم المستخدم هذا');
      email = found.trim();
      if (email.isEmpty) throw Exception('لا يوجد حساب مرتبط باسم المستخدم هذا');
    }

    try {
      return await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      final msg = e is Exception ? e.toString() : e.toString();
      if (msg.contains('غير صحيحة') || msg.contains('invalid') || msg.contains('credential')) {
        throw Exception(
          'البيانات غير صحيحة. تأكد من كلمة المرور. إذا أنشأت الحساب عبر Google فاستخدم زر Google لتسجيل الدخول.',
        );
      }
      rethrow;
    }
  }
}
