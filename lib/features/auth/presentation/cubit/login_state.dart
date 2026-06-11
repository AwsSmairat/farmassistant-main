// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: login_state.dart
// المسار: features/auth/presentation/cubit/login_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • LoginState
//   • enum LoginStatus
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
part of 'login_cubit.dart';

/// تعداد تسجيل الدخول الحالة.
enum LoginStatus { initial, loading, success, failure, googleSignInNeedsProfile }

/// حالة واجهة تسجيل الدخول.
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

  /// حقل: الحالة.
  final LoginStatus status;
  /// حقل: المستخدم.
  final AuthUser? user;
  /// حقل: message.
  final String? message;

  @override
  /// يُرجع props.
  List<Object?> get props => [status, user, message];
}
