// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: resilient_ai_diagnosis_service.dart
// المسار: features/ai_plant_diagnosis/data/services/resilient_ai_diagnosis_service.dart
// الطبقة: data / services — خدمة بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. خدمة تنفيذ منطق أو اتصال خارجي.
//
// ماذا بداخله؟
//   • ResilientAiDiagnosisService
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/failures/plant_diagnosis_failure.dart';
import '../../domain/services/ai_diagnosis_service.dart';
import 'firebase_ai_diagnosis_service.dart';
import 'mock_ai_diagnosis_service.dart';

/// Tries cloud diagnosis first; falls back to [MockAiDiagnosisService] only when
/// خدمة مرن الذكاء الاصطناعي التشخيص.
class ResilientAiDiagnosisService implements AiDiagnosisService {
  ResilientAiDiagnosisService({
    required FirebaseAiDiagnosisService firebase,
    required MockAiDiagnosisService mock,
  })  : _firebase = firebase,
        _mock = mock;

  /// حقل: Firebase.
  final FirebaseAiDiagnosisService _firebase;
  /// حقل: وهمي.
  final MockAiDiagnosisService _mock;

  @override
  /// يحلّل النبات الصورة.
  Future<PlantDiagnosisResult> analyzePlantImage(XFile image) async {
    try {
      return await _firebase.analyzePlantImage(image);
    } on PlantDiagnosisFailure catch (e) {
      if (e.reason == PlantDiagnosisFailureReason.cloudFunctionNotConfigured) {
        return _mock.analyzePlantImage(image);
      }
      rethrow;
    }
  }
}
