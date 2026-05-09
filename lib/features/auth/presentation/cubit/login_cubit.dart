import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/app_exceptions.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/usecases/sign_in_with_identifier.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required SignInWithIdentifier signInWithIdentifier,
    required SignInWithGoogle signInWithGoogle,
    required UserProfileRepository userProfileRepository,
    required SignOut signOut,
  })  : _signInWithIdentifier = signInWithIdentifier,
        _signInWithGoogle = signInWithGoogle,
        _userProfileRepository = userProfileRepository,
        _signOut = signOut,
        super(const LoginState.initial());

  final SignInWithIdentifier _signInWithIdentifier;
  final SignInWithGoogle _signInWithGoogle;
  final UserProfileRepository _userProfileRepository;
  final SignOut _signOut;

  Future<void> signInWithIdentifier({
    required String identifier,
    required String password,
  }) async {
    emit(const LoginState.loading());
    try {
      final user = await _signInWithIdentifier(
        identifier: identifier,
        password: password,
      );
      emit(LoginState.success(user));
    } catch (e, _) {
      emit(LoginState.failure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const LoginState.loading());
    try {
      final user = await _signInWithGoogle();
      final hasProfile = await _userProfileRepository.hasProfile(user.id);
      if (hasProfile) {
        emit(LoginState.success(user));
      } else {
        emit(LoginState.googleSignInNeedsProfile(user));
      }
    } on GoogleRedirectPendingException {
      emit(const LoginState.loading());
    } catch (e, _) {
      emit(LoginState.failure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }

  /// Call after user fills the Google profile dialog (username, phone, password).
  Future<void> completeGoogleProfile({
    required AuthUser user,
    required String username,
    required String phone,
    required String password,
  }) async {
    assert(password.isNotEmpty);
    emit(const LoginState.loading());
    try {
      final email = user.email ?? '';
      if (email.isEmpty) {
        emit(const LoginState.failure('البريد الإلكتروني غير متوفر'));
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
      emit(LoginState.success(user));
    } catch (e, _) {
      emit(LoginState.failure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }

  /// Cancel Google profile dialog: sign out and reset.
  Future<void> cancelGoogleProfile() async {
    await _signOut();
    emit(const LoginState.initial());
  }

  void reset() => emit(const LoginState.initial());
}
