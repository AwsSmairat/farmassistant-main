import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class StreamAuthState {
  StreamAuthState(this._repository);

  final AuthRepository _repository;

  Stream<AuthUser?> call() => _repository.authStateChanges;
}
