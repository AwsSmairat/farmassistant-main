// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: plant_diagnosis_failure.dart
// المسار: features/ai_plant_diagnosis/domain/failures/plant_diagnosis_failure.dart
// الطبقة: domain / failures — أخطاء المجال
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. جزء من ميزة تشخيص النبات بالذكاء الاصطناعي.
//
// ماذا بداخله؟
//   • PlantDiagnosisFailure
//   • enum PlantDiagnosisFailureReason
//   • plantDiagnosisFailureMessageAr()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// خطأ/فشل: النبات التشخيص فشل reason.
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

  /// Upload or cloud call exceeded the client/server time limit.
  analysisTimedOut,
}
/// خطأ/فشل: النبات التشخيص فشل.
class PlantDiagnosisFailure implements Exception {
  /// دالة النبات التشخيص فشل.
  const PlantDiagnosisFailure(this.reason, {this.technical});

  /// حقل: reason.
  final PlantDiagnosisFailureReason reason;
  /// حقل: technical.
  final Object? technical;

  @override
  /// دالة to string.
  String toString() => 'PlantDiagnosisFailure($reason, $technical)';
}

/// User-facing Arabic messages for [PlantDiagnosisFailure].
/// دالة النبات التشخيص فشل message ar.
String plantDiagnosisFailureMessageAr(PlantDiagnosisFailureReason reason) {
  /// دالة switch.
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
    PlantDiagnosisFailureReason.analysisTimedOut =>
      'استغرق الخادم وقتاً أطول من مهلة الانتظار (قد يحدث عند أول طلب أو عند ضغط على خدمة الذكاء الاصطناعي). انتظر قليلاً ثم اضغط «تحليل الصورة» مرة أخرى.',
  };
}
