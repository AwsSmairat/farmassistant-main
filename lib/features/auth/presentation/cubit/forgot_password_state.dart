// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: forgot_password_state.dart
// المسار: features/auth/presentation/cubit/forgot_password_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • ForgotPasswordState
//   • enum ForgotPasswordStatus
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
part of 'forgot_password_cubit.dart';

/// تعداد نسيت كلمة المرور الحالة.
enum ForgotPasswordStatus { initial, loading, success, failure }

/// حالة واجهة نسيت كلمة المرور.
class ForgotPasswordState extends Equatable {
  const ForgotPasswordState._({required this.status, this.message});

  const ForgotPasswordState.initial()
      : this._(status: ForgotPasswordStatus.initial);

  const ForgotPasswordState.loading()
      : this._(status: ForgotPasswordStatus.loading);

  const ForgotPasswordState.success()
      : this._(status: ForgotPasswordStatus.success);

  const ForgotPasswordState.failure(String message)
      : this._(status: ForgotPasswordStatus.failure, message: message);

  /// حقل: الحالة.
  final ForgotPasswordStatus status;
  /// حقل: message.
  final String? message;

  @override
  /// يُرجع props.
  List<Object?> get props => [status, message];
}
