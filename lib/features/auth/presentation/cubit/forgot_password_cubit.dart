import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/send_password_reset.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._sendPasswordReset)
      : super(const ForgotPasswordState.initial());

  final SendPasswordReset _sendPasswordReset;

  Future<void> sendResetEmail(String email) async {
    emit(const ForgotPasswordState.loading());
    try {
      await _sendPasswordReset(email);
      emit(const ForgotPasswordState.success());
    } catch (e, _) {
      emit(ForgotPasswordState.failure(e.toString()));
    }
  }

  void reset() => emit(const ForgotPasswordState.initial());
}
