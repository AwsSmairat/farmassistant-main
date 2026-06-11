// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: signup_state.dart
// المسار: features/auth/presentation/cubit/signup_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • SignupState
//   • enum SignupStatus
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
part of 'signup_cubit.dart';

/// تعداد إنشاء حساب الحالة.
enum SignupStatus {
  initial,
  loading,
  success,
  failure,
  googleNeedsProfile,
}

/// حالة واجهة إنشاء حساب.
class SignupState extends Equatable {
  const SignupState._({
    required this.status,
    this.user,
    this.message,
    this.showEmailVerificationDialog = false,
  });

  const SignupState.initial()
      : this._(status: SignupStatus.initial);

  const SignupState.loading()
      : this._(status: SignupStatus.loading);

  const SignupState.success(
    AuthUser user, {
    bool showEmailVerificationDialog = true,
  }) : this._(
          status: SignupStatus.success,
          user: user,
          showEmailVerificationDialog: showEmailVerificationDialog,
        );

  const SignupState.failure(String message)
      : this._(status: SignupStatus.failure, message: message);

  const SignupState.googleNeedsProfile(AuthUser user)
      : this._(
          status: SignupStatus.googleNeedsProfile,
          user: user,
        );

  /// حقل: الحالة.
  final SignupStatus status;
  /// حقل: المستخدم.
  final AuthUser? user;
  /// حقل: message.
  final String? message;

  /// When true after [SignupStatus.success], show email verification dialog (email/password signup).
  /// حقل: show البريد verification حوار.
  final bool showEmailVerificationDialog;

  @override
  /// يُرجع props.
  List<Object?> get props =>
      [status, user, message, showEmailVerificationDialog];
}
