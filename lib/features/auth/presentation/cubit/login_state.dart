part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure, googleSignInNeedsProfile }

class LoginState extends Equatable {
  const LoginState._({required this.status, this.user, this.message});

  const LoginState.initial()
      : this._(status: LoginStatus.initial);

  const LoginState.loading()
      : this._(status: LoginStatus.loading);

  const LoginState.success(AuthUser user)
      : this._(status: LoginStatus.success, user: user);

  const LoginState.failure(String message)
      : this._(status: LoginStatus.failure, message: message);

  /// Google sign-in succeeded but user has no profile; show dialog to complete.
  const LoginState.googleSignInNeedsProfile(AuthUser user)
      : this._(status: LoginStatus.googleSignInNeedsProfile, user: user);

  final LoginStatus status;
  final AuthUser? user;
  final String? message;

  @override
  List<Object?> get props => [status, user, message];
}
