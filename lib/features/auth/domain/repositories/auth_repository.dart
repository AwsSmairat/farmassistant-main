// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: auth_repository.dart
// المسار: features/auth/domain/repositories/auth_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • AuthRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/auth_user.dart';
/// واجهة مستودع المصادقة.
abstract class AuthRepository {
  /// Current user stream (null when signed out).
  Stream<AuthUser?> get authStateChanges;

  /// Current user or null.
  AuthUser? get currentUser;

  /// Sign in with email and password.
  /// يسجّل دخول with البريد and كلمة المرور.
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Create account with email and password.
  /// ينشئ المستخدم with البريد and كلمة المرور.
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Send email verification to the current user. No-op if no user.
  /// يرسل البريد verification.
  Future<void> sendEmailVerification();

  /// Deletes the current user (e.g. after sign-up if profile creation fails).
  /// يحذف current المستخدم.
  Future<void> deleteCurrentUser();

  /// Send password reset email to [email].
  /// يرسل كلمة المرور إعادة تعيين البريد.
  Future<void> sendPasswordResetEmail(String email);

  /// Sign in with Google.
  /// يسجّل دخول with جوجل.
  Future<AuthUser> signInWithGoogle();

  /// Sign out.
  /// يسجّل خروج.
  Future<void> signOut();

  /// Web: completes Google sign-in after [signInWithRedirect] return (Safari / popup blocked).
  /// دالة complete ويب redirect تسجيل in if needed.
  Future<void> completeWebRedirectSignInIfNeeded();
}
