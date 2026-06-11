// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: stream_auth_state.dart
// المسار: features/auth/domain/usecases/stream_auth_state.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. شكل بيانات الحالة للواجهة — عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • StreamAuthState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// حالة واجهة البث المصادقة.
class StreamAuthState {
  StreamAuthState(this._repository);

  /// حقل: مستودع.
  final AuthRepository _repository;

  /// دالة call.
  Stream<AuthUser?> call() => _repository.authStateChanges;
}
