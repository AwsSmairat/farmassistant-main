/// App-level exceptions used across layers (domain can depend on core).
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class PermissionDeniedException extends AppException {
  const PermissionDeniedException([super.message = 'لا توجد صلاحية للوصول إلى البيانات.']);
}

/// Web-only: [signInWithRedirect] was started; the page will reload — callers should not show failure.
final class GoogleRedirectPendingException implements Exception {
  const GoogleRedirectPendingException();
}

