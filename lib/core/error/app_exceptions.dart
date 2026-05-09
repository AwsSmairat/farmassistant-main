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

