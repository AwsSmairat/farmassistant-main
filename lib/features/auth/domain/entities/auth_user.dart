import 'package:equatable/equatable.dart';

/// Domain entity: authenticated user (backend-agnostic).
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, isEmailVerified];
}
