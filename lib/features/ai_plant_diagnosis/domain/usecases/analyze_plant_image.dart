// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: analyze_plant_image.dart
// المسار: features/ai_plant_diagnosis/domain/usecases/analyze_plant_image.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • AnalyzePlantImage
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:image_picker/image_picker.dart';

import '../entities/plant_diagnosis_result.dart';
import '../services/ai_diagnosis_service.dart';

/// كلاس تحليل النبات الصورة.
class AnalyzePlantImage {
  AnalyzePlantImage(this._service);

  /// حقل: خدمة.
  final AiDiagnosisService _service;

  /// دالة call.
  Future<PlantDiagnosisResult> call(XFile image) =>
      _service.analyzePlantImage(image);
}
