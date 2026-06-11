// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_exceptions.dart
// المسار: core/error/app_exceptions.dart
// الطبقة: core / error — الأخطاء
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • app_exceptions
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// App-level exceptions used across layers (domain can depend on core).
sealed class AppException implements Exception {
  /// دالة التطبيق استثناء.
  const AppException(this.message);

  /// حقل: message.
  final String message;

  @override
  /// دالة to string.
  String toString() => message;
}

final class PermissionDeniedException extends AppException {
  /// دالة permission denied استثناء.
  const PermissionDeniedException([super.message = 'لا توجد صلاحية للوصول إلى البيانات.']);
}

/// Web-only: [signInWithRedirect] was started; the page will reload — callers should not show failure.
final class GoogleRedirectPendingException implements Exception {
  /// دالة جوجل redirect pending استثناء.
  const GoogleRedirectPendingException();
}

