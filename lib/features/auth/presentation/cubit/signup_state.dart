part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  const SignupState._({required this.status, this.user, this.message});

  const SignupState.initial()
      : this._(status: SignupStatus.initial);

  const SignupState.loading()
      : this._(status: SignupStatus.loading);

  const SignupState.success(AuthUser user)
      : this._(status: SignupStatus.success, user: user);

  const SignupState.failure(String message)
      : this._(status: SignupStatus.failure, message: message);

  final SignupStatus status;
  final AuthUser? user;
  final String? message;

  @override
  List<Object?> get props => [status, user, message];
}
