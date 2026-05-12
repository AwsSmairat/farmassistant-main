/// Typed failures for phone plant diagnosis (upload, callable, parsing).
enum PlantDiagnosisFailureReason {
  /// Storage upload failed.
  uploadFailed,

  /// Callable returned an error or AI pipeline failed.
  cloudFunctionFailed,

  /// No network connectivity.
  noInternet,

  /// Image type/size rejected.
  unsupportedImage,

  /// Response JSON missing or invalid.
  invalidAiResponse,

  /// Function not deployed or server reports AI not configured (use mock fallback).
  cloudFunctionNotConfigured,

  /// User must be signed in for cloud diagnosis.
  notAuthenticated,
}

/// Exception carrying a [PlantDiagnosisFailureReason] for mapping to Arabic UI strings.
class PlantDiagnosisFailure implements Exception {
  const PlantDiagnosisFailure(this.reason, {this.technical});

  final PlantDiagnosisFailureReason reason;
  final Object? technical;

  @override
  String toString() => 'PlantDiagnosisFailure($reason, $technical)';
}

/// User-facing Arabic messages for [PlantDiagnosisFailure].
String plantDiagnosisFailureMessageAr(PlantDiagnosisFailureReason reason) {
  return switch (reason) {
    PlantDiagnosisFailureReason.uploadFailed =>
      'تعذر رفع الصورة. تحقق من الاتصال أو مساحة التخزين وحاول مرة أخرى.',
    PlantDiagnosisFailureReason.cloudFunctionFailed =>
      'تعذر إكمال التحليل على السحابة. حاول لاحقاً.',
    PlantDiagnosisFailureReason.noInternet =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة ثم أعد المحاولة.',
    PlantDiagnosisFailureReason.unsupportedImage =>
      'صورة غير مدعومة أو كبيرة جداً. استخدم JPG أو PNG بحجم أقل.',
    PlantDiagnosisFailureReason.invalidAiResponse =>
      'استجابة غير صالحة من خدمة الذكاء الاصطناعي. حاول بصورة أوضح.',
    PlantDiagnosisFailureReason.cloudFunctionNotConfigured =>
      'خدمة التحليل السحابية غير مهيأة حالياً.',
    PlantDiagnosisFailureReason.notAuthenticated =>
      'يجب تسجيل الدخول لاستخدام التحليل السحابي.',
  };
}
