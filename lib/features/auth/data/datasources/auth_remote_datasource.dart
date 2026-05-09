import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_user_model.dart';
import '../../domain/entities/auth_user.dart';

GoogleSignIn _createGoogleSignIn() {
  if (kIsWeb) {
    const clientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
    if (clientId.isNotEmpty) {
      return GoogleSignIn(clientId: clientId);
    }
  }
  return GoogleSignIn();
}

/// Remote auth operations. All Firebase/Google logic stays here.
class AuthRemoteDatasource {
  AuthRemoteDatasource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? _createGoogleSignIn();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<AuthUser?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_userOrNull);

  AuthUser? get currentUser => _userOrNull(_firebaseAuth.currentUser);

  AuthUser? _userOrNull(firebase_auth.User? u) =>
      u == null ? null : AuthUserModel.fromFirebaseUser(u);

  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) throw Exception('Sign in failed');
      return AuthUserModel.fromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) throw Exception('Create account failed');
      return AuthUserModel.fromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> deleteCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) await user.delete();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  Future<AuthUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('تم إلغاء تسجيل الدخول بـ Google');
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      // On Web, accessToken is often null while idToken is enough for Firebase.
      if (idToken == null) {
        throw Exception(
          'لم يُستلم رمز تعريف من Google. على الويب: أضف GOOGLE_WEB_CLIENT_ID أو وسّم '
          'google-signin-client_id في index.html، وفعّل Google في Firebase Authentication.',
        );
      }
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: idToken,
      );
      final cred = await _firebaseAuth.signInWithCredential(credential);
      final user = cred.user;
      if (user == null) throw Exception('فشل تسجيل الدخول بـ Google');
      return AuthUserModel.fromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Maps Firebase auth error codes to user-friendly Arabic messages.
  static String _authErrorMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'invalid-email':
      case 'wrong-password':
      case 'user-disabled':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة. تحقق من البيانات أو استخدم "نسيت كلمة المرور".';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد. أنشئ حساباً جديداً أو تحقق من البريد.';
      case 'email-already-in-use':
        return 'هذا البريد مسجّل مسبقاً. سجّل دخولاً أو استخدم "نسيت كلمة المرور".';
      case 'weak-password':
        return 'كلمة المرور ضعيفة. استخدم 6 أحرف على الأقل.';
      case 'operation-not-allowed':
        return 'طريقة تسجيل الدخول غير مفعّلة في إعدادات Firebase.';
      case 'network-request-failed':
        return 'تحقق من الاتصال بالإنترنت وحاول مرة أخرى.';
      case 'too-many-requests':
        return 'محاولات كثيرة. انتظر قليلاً ثم حاول مرة أخرى.';
      default:
        return e.message ?? 'حدث خطأ أثناء تسجيل الدخول.';
    }
  }
}
