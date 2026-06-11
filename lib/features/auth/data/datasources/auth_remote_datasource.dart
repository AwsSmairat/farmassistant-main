// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: auth_remote_datasource.dart
// المسار: features/auth/data/datasources/auth_remote_datasource.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. الاتصال بـ Firebase أو API.
//
// ماذا بداخله؟
//   • AuthRemoteDatasource
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/app_exceptions.dart';
import '../models/auth_user_model.dart';
import '../../domain/entities/auth_user.dart';

/// Remote auth operations. All Firebase/Google logic stays here.
///
/// **Web:** Google uses [FirebaseAuth.signInWithPopup] (no `google_sign_in_web` ClientID).
/// مصدر بيانات المصادقة بعيد مصدر بيانات.
class AuthRemoteDatasource {
  AuthRemoteDatasource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = kIsWeb ? null : (googleSignIn ?? GoogleSignIn());

  final firebase_auth.FirebaseAuth _firebaseAuth;
  /// Null on web — avoids `google_sign_in_web` requiring OAuth Client ID in HTML.
  /// حقل: جوجل تسجيل in.
  final GoogleSignIn? _googleSignIn;

  /// يُرجع المصادقة الحالة changes.
  Stream<AuthUser?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_userOrNull);

  /// يُرجع current المستخدم.
  AuthUser? get currentUser => _userOrNull(_firebaseAuth.currentUser);

  /// دالة داخلية: المستخدم or null.
  AuthUser? _userOrNull(firebase_auth.User? u) =>
      u == null ? null : AuthUserModel.fromFirebaseUser(u);

  /// يسجّل دخول with البريد and كلمة المرور.
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

  /// ينشئ المستخدم with البريد and كلمة المرور.
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

  /// يرسل البريد verification.
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// يحذف current المستخدم.
  Future<void> deleteCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) await user.delete();
  }

  /// يرسل كلمة المرور إعادة تعيين البريد.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  /// يسجّل دخول with جوجل.
  Future<AuthUser> signInWithGoogle() async {
    if (kIsWeb) {
      return _signInWithGoogleWeb();
    }
    return _signInWithGoogleMobile();
  }

  firebase_auth.GoogleAuthProvider _googleAuthProviderWeb() {
    final provider = firebase_auth.GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');
    provider.setCustomParameters(const {'prompt': 'select_account'});
    return provider;
  }

  /// Call once at startup on web after returning from [signInWithRedirect] (e.g. Safari).
  /// دالة complete redirect تسجيل in if needed.
  Future<void> completeRedirectSignInIfNeeded() async {
    if (!kIsWeb) return;
    try {
      await _firebaseAuth.getRedirectResult();
    } catch (_) {}
  }

  /// دالة داخلية: تسجيل in with جوجل ويب.
  Future<AuthUser> _signInWithGoogleWeb() async {
    try {
      final provider = _googleAuthProviderWeb();
      final cred = await _firebaseAuth.signInWithPopup(provider);
      final user = cred.user;
      if (user == null) throw Exception('فشل تسجيل الدخول بـ Google');
      return AuthUserModel.fromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      final code = e.code.toLowerCase();
      if (code.contains('popup') ||
          code == 'popup-blocked' ||
          code == 'cancelled-popup-request') {
        await _firebaseAuth.signInWithRedirect(_googleAuthProviderWeb());
        /// دالة جوجل redirect pending استثناء.
        throw const GoogleRedirectPendingException();
      }
      throw Exception(_authErrorMessage(e));
    } catch (e) {
      if (e is GoogleRedirectPendingException) rethrow;
      if (e is Exception) rethrow;
      throw Exception('فشل تسجيل الدخول بـ Google: $e');
    }
  }

  /// دالة داخلية: تسجيل in with جوجل mobile.
  Future<AuthUser> _signInWithGoogleMobile() async {
    final googleSignIn = _googleSignIn;
    if (googleSignIn == null) {
      throw Exception('Google Sign-In غير مهيأ على هذه المنصة.');
    }
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw Exception('تم إلغاء تسجيل الدخول بـ Google');
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        /// دالة استثناء.
        throw Exception(
          'فشل الحصول على رمز تعريف من Google. تأكد من إعداد تسجيل الدخول في Firebase.',
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
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل تسجيل الدخول بـ Google: $e');
    }
  }

  /// يسجّل خروج.
  Future<void> signOut() async {
    final googleSignIn = _googleSignIn;
    final hadSession = _firebaseAuth.currentUser != null;

    StreamSubscription<firebase_auth.User?>? authListener;
    Future<void>? waitUntilNull;
    if (hadSession) {
      final signedOut = Completer<void>();
      authListener = _firebaseAuth.authStateChanges().listen((user) {
        if (user == null && !signedOut.isCompleted) {
          signedOut.complete();
        }
      });
      waitUntilNull = signedOut.future.timeout(const Duration(seconds: 15));
    }

    try {
      await _firebaseAuth.signOut();
      if (googleSignIn != null) {
        await googleSignIn.signOut();
      }
      if (waitUntilNull != null) {
        try {
          await waitUntilNull;
        } on TimeoutException {
          // Channel stalled; avoid hanging logout indefinitely.
        }
      }
    } finally {
      await authListener?.cancel();
    }

    if (kIsWeb) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  /// Maps Firebase auth error codes to user-friendly Arabic messages.
  /// دالة داخلية: المصادقة خطأ message.
  static String _authErrorMessage(firebase_auth.FirebaseAuthException e) {
  /// دالة switch.
    switch (e.code) {
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'تم إغلاق نافذة Google. حاول مرة أخرى.';
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
