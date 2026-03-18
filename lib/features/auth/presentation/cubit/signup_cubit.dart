import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/create_account_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required CreateAccountWithEmail createAccountWithEmail,
    required SignInWithGoogle signInWithGoogle,
  })  : _createAccountWithEmail = createAccountWithEmail,
        _signInWithGoogle = signInWithGoogle,
        super(const SignupState.initial());

  final CreateAccountWithEmail _createAccountWithEmail;
  final SignInWithGoogle _signInWithGoogle;

  Future<void> createAccountWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const SignupState.loading());
    try {
      final user = await _createAccountWithEmail(email: email, password: password);
      emit(SignupState.success(user));
    } catch (e, _) {
      emit(SignupState.failure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const SignupState.loading());
    try {
      final user = await _signInWithGoogle();
      emit(SignupState.success(user));
    } catch (e, _) {
      emit(SignupState.failure(e.toString()));
    }
  }

  void reset() => emit(const SignupState.initial());
}
