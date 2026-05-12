import 'package:image_picker/image_picker.dart';

import '../entities/plant_diagnosis_result.dart';
import '../repositories/ai_diagnosis_record_repository.dart';

class SaveAiDiagnosisRecord {
  SaveAiDiagnosisRecord(this._repository);

  final AiDiagnosisRecordRepository _repository;

  Future<void> call({
    required PlantDiagnosisResult result,
    required XFile image,
  }) {
    return _repository.saveAppUploadDiagnosis(result: result, image: image);
  }
}
