part of 'signup_cubit.dart';

enum SignupStatus {
  initial,
  loading,
  success,
  failure,
  googleNeedsProfile,
}

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

  final SignupStatus status;
  final AuthUser? user;
  final String? message;

  /// When true after [SignupStatus.success], show email verification dialog (email/password signup).
  final bool showEmailVerificationDialog;

  @override
  List<Object?> get props =>
      [status, user, message, showEmailVerificationDialog];
}
