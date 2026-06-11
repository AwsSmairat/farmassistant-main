// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: forgot_password_cubit.dart
// المسار: features/auth/presentation/cubit/forgot_password_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • ForgotPasswordCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/send_password_reset.dart';

part 'forgot_password_state.dart';

/// منطق الواجهة (Cubit) لـ نسيت كلمة المرور.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._sendPasswordReset)
      : super(const ForgotPasswordState.initial());

  /// حقل: إرسال كلمة المرور إعادة تعيين.
  final SendPasswordReset _sendPasswordReset;

  /// يرسل إعادة تعيين البريد.
  Future<void> sendResetEmail(String email) async {
  /// يصدّر حالة جديدة.
    emit(const ForgotPasswordState.loading());
    try {
      await _sendPasswordReset(email);
      emit(const ForgotPasswordState.success());
    } catch (e, _) {
      emit(ForgotPasswordState.failure(e.toString()));
    }
  }

  /// دالة إعادة تعيين.
  void reset() => emit(const ForgotPasswordState.initial());
}
