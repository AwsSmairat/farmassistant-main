// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: save_ai_diagnosis_record.dart
// المسار: features/ai_plant_diagnosis/domain/usecases/save_ai_diagnosis_record.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • SaveAiDiagnosisRecord
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:image_picker/image_picker.dart';

import '../entities/plant_diagnosis_result.dart';
import '../repositories/ai_diagnosis_record_repository.dart';

/// كلاس حفظ الذكاء الاصطناعي التشخيص سجل.
class SaveAiDiagnosisRecord {
  SaveAiDiagnosisRecord(this._repository);

  /// حقل: مستودع.
  final AiDiagnosisRecordRepository _repository;

  /// دالة call.
  Future<void> call({
    required PlantDiagnosisResult result,
    required XFile image,
  }) {
    return _repository.saveAppUploadDiagnosis(result: result, image: image);
  }
}
