import 'package:image_picker/image_picker.dart';

import '../entities/plant_diagnosis_result.dart';

/// Persists a single diagnosis row + optional image object in Firebase.
abstract class AiDiagnosisRecordRepository {
  Future<void> saveAppUploadDiagnosis({
    required PlantDiagnosisResult result,
    required XFile image,
  });
}
