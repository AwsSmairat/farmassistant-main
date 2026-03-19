import '../entities/auth_user.dart';

/// Contract for authentication. Implementation lives in data layer.
abstract class AuthRepository {
  /// Current user stream (null when signed out).
  Stream<AuthUser?> get authStateChanges;

  /// Current user or null.
  AuthUser? get currentUser;

  /// Sign in with email and password.
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Create account with email and password.
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Send email verification to the current user. No-op if no user.
  Future<void> sendEmailVerification();

  /// Deletes the current user (e.g. after sign-up if profile creation fails).
  Future<void> deleteCurrentUser();

  /// Send password reset email to [email].
  Future<void> sendPasswordResetEmail(String email);

  /// Sign in with Google.
  Future<AuthUser> signInWithGoogle();

  /// Sign out.
  Future<void> signOut();
}
