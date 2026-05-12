import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/failures/plant_diagnosis_failure.dart';
import '../../domain/services/ai_diagnosis_service.dart';
import 'firebase_ai_diagnosis_service.dart';
import 'mock_ai_diagnosis_service.dart';

/// Tries cloud diagnosis first; falls back to [MockAiDiagnosisService] only when
/// the Cloud Function is missing or the server reports AI is not configured.
class ResilientAiDiagnosisService implements AiDiagnosisService {
  ResilientAiDiagnosisService({
    required FirebaseAiDiagnosisService firebase,
    required MockAiDiagnosisService mock,
  })  : _firebase = firebase,
        _mock = mock;

  final FirebaseAiDiagnosisService _firebase;
  final MockAiDiagnosisService _mock;

  @override
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
