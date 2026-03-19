import 'package:equatable/equatable.dart';

sealed class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState();

  @override
  List<Object?> get props => [];
}

final class PrivacyPolicyInitial extends PrivacyPolicyState {
  const PrivacyPolicyInitial();
}

final class PrivacyPolicyLoading extends PrivacyPolicyState {
  const PrivacyPolicyLoading();
}

final class PrivacyPolicyLoaded extends PrivacyPolicyState {
  const PrivacyPolicyLoaded(this.content);

  final String content;

  @override
  List<Object?> get props => [content];
}

final class PrivacyPolicySaving extends PrivacyPolicyState {
  const PrivacyPolicySaving(this.content);

  final String content;

  @override
  List<Object?> get props => [content];
}

final class PrivacyPolicyFailure extends PrivacyPolicyState {
  const PrivacyPolicyFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
