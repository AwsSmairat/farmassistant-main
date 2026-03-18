import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required SignInWithEmail signInWithEmail,
    required SignInWithGoogle signInWithGoogle,
  })  : _signInWithEmail = signInWithEmail,
        _signInWithGoogle = signInWithGoogle,
        super(const LoginState.initial());

  final SignInWithEmail _signInWithEmail;
  final SignInWithGoogle _signInWithGoogle;

  Future<void> signInWithEmail({required String email, required String password}) async {
    emit(const LoginState.loading());
    try {
      final user = await _signInWithEmail(email: email, password: password);
      emit(LoginState.success(user));
    } catch (e, _) {
      emit(LoginState.failure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const LoginState.loading());
    try {
      final user = await _signInWithGoogle();
      emit(LoginState.success(user));
    } catch (e, _) {
      emit(LoginState.failure(e.toString()));
    }
  }

  void reset() => emit(const LoginState.initial());
}
