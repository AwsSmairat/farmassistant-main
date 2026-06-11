// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_diagnosis_record_repository_impl.dart
// المسار: features/ai_plant_diagnosis/data/repositories/ai_diagnosis_record_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • AiDiagnosisRecordRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/repositories/ai_diagnosis_record_repository.dart';
import '../datasources/ai_diagnosis_remote_datasource.dart';

/// تنفيذ مستودع الذكاء الاصطناعي التشخيص سجل.
class AiDiagnosisRecordRepositoryImpl implements AiDiagnosisRecordRepository {
  AiDiagnosisRecordRepositoryImpl(this._remote);

  /// حقل: بعيد.
  final AiDiagnosisRemoteDatasource _remote;

  @override
  /// يحفظ التطبيق رفع التشخيص.
  Future<void> saveAppUploadDiagnosis({
    required PlantDiagnosisResult result,
    required XFile image,
  }) {
    return _remote.savePhoneUploadDiagnosis(result: result, image: image);
  }
}
