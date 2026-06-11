// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_diagnosis_record_repository.dart
// المسار: features/ai_plant_diagnosis/domain/repositories/ai_diagnosis_record_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • AiDiagnosisRecordRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:image_picker/image_picker.dart';

import '../entities/plant_diagnosis_result.dart';
/// واجهة مستودع الذكاء الاصطناعي التشخيص سجل.
abstract class AiDiagnosisRecordRepository {
  /// يحفظ التطبيق رفع التشخيص.
  Future<void> saveAppUploadDiagnosis({
    required PlantDiagnosisResult result,
    required XFile image,
  });
}
