// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: auth_repository_impl.dart
// المسار: features/auth/data/repositories/auth_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • AuthRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// تنفيذ مستودع المصادقة.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);

  /// حقل: مصدر بيانات.
  final AuthRemoteDatasource _datasource;

  @override
  /// يُرجع المصادقة الحالة changes.
  Stream<AuthUser?> get authStateChanges => _datasource.authStateChanges;

  @override
  /// يُرجع current المستخدم.
  AuthUser? get currentUser => _datasource.currentUser;

  @override
  /// يسجّل دخول with البريد and كلمة المرور.
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _datasource.signInWithEmailAndPassword(email: email, password: password);

  @override
  /// ينشئ المستخدم with البريد and كلمة المرور.
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _datasource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  /// يرسل البريد verification.
  Future<void> sendEmailVerification() =>
      _datasource.sendEmailVerification();

  @override
  /// يحذف current المستخدم.
  Future<void> deleteCurrentUser() => _datasource.deleteCurrentUser();

  @override
  /// يرسل كلمة المرور إعادة تعيين البريد.
  Future<void> sendPasswordResetEmail(String email) =>
      _datasource.sendPasswordResetEmail(email);

  @override
  /// يسجّل دخول with جوجل.
  Future<AuthUser> signInWithGoogle() => _datasource.signInWithGoogle();

  @override
  /// يسجّل خروج.
  Future<void> signOut() => _datasource.signOut();

  @override
  /// دالة complete ويب redirect تسجيل in if needed.
  Future<void> completeWebRedirectSignInIfNeeded() =>
      _datasource.completeRedirectSignInIfNeeded();
}
