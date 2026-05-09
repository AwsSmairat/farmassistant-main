import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/app_exceptions.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/usecases/create_account_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required CreateAccountWithEmail createAccountWithEmail,
    required SignInWithGoogle signInWithGoogle,
    required UserProfileRepository userProfileRepository,
    required SignOut signOut,
  })  : _createAccountWithEmail = createAccountWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _userProfileRepository = userProfileRepository,
        _signOut = signOut,
        super(const SignupState.initial());

  final CreateAccountWithEmail _createAccountWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final UserProfileRepository _userProfileRepository;
  final SignOut _signOut;

  Future<void> createAccountWithEmail({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    emit(const SignupState.loading());
    try {
      final user = await _createAccountWithEmail(
        email: email,
        password: password,
        username: username,
        phone: phone,
      );
      emit(SignupState.success(user));
    } catch (e, _) {
      emit(SignupState.failure(_mapSignupError(e)));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const SignupState.loading());
    try {
      final user = await _signInWithGoogle();
      final hasProfile = await _userProfileRepository.hasProfile(user.id);
      if (hasProfile) {
        emit(SignupState.success(user, showEmailVerificationDialog: false));
      } else {
        emit(SignupState.googleNeedsProfile(user));
      }
    } on GoogleRedirectPendingException {
      emit(const SignupState.loading());
    } catch (e, _) {
      emit(SignupState.failure(_mapSignupError(e)));
    }
  }

  Future<void> completeGoogleProfile({
    required AuthUser user,
    required String username,
    required String phone,
    required String password,
  }) async {
    assert(password.isNotEmpty);
    emit(const SignupState.loading());
    try {
      final email = user.email ?? '';
      if (email.isEmpty) {
        emit(const SignupState.failure('البريد الإلكتروني غير متوفر'));
        return;
      }
      final raw = phone.trim().replaceAll(RegExp(r'\s'), '');
      final phoneFull = raw.isEmpty
          ? ''
          : raw.startsWith('+')
              ? raw
              : raw.startsWith('962')
                  ? '+$raw'
                  : '+962$raw';
      await _userProfileRepository.createProfile(
        uid: user.id,
        username: username.trim(),
        phone: phoneFull.isEmpty ? phone.trim() : phoneFull,
        email: email,
      );
      emit(SignupState.success(user, showEmailVerificationDialog: false));
    } catch (e, _) {
      emit(SignupState.failure(_mapSignupError(e)));
    }
  }

  Future<void> cancelGoogleProfile() async {
    await _signOut();
    emit(const SignupState.initial());
  }

  static String _mapSignupError(Object e) {
    if (e is PermissionDeniedException) {
      return '${e.message} انشر قواعد Firestore من المجلد (ملف firestore.rules) عبر: firebase deploy --only firestore:rules';
    }
    if (e is Exception) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    return e.toString();
  }

  void reset() => emit(const SignupState.initial());
}
