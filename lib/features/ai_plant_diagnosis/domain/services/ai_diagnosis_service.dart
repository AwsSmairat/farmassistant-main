// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_diagnosis_service.dart
// المسار: features/ai_plant_diagnosis/domain/services/ai_diagnosis_service.dart
// الطبقة: domain / services — واجهة خدمة
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. خدمة تنفيذ منطق أو اتصال خارجي.
//
// ماذا بداخله؟
//   • AiDiagnosisService
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:image_picker/image_picker.dart';

import '../entities/plant_diagnosis_result.dart';

/// Contract for on-device, edge, or cloud plant inference.
///
/// Today: [MockAiDiagnosisService]. Later: swap binding to Raspberry Pi HTTP,
/// Cloud Functions, TFLite isolate, or a third-party vision API — without
/// changing presentation.
///
/// Uses [XFile] (from [image_picker]) so the same flow works on mobile, web,
/// and desktop. When you only have a `dart:io` [File], call
/// خدمة الذكاء الاصطناعي التشخيص.
abstract class AiDiagnosisService {
  /// يحلّل النبات الصورة.
  Future<PlantDiagnosisResult> analyzePlantImage(XFile image);
}
