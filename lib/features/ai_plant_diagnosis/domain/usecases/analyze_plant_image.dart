import 'package:image_picker/image_picker.dart';

import '../entities/plant_diagnosis_result.dart';
import '../services/ai_diagnosis_service.dart';

class AnalyzePlantImage {
  AnalyzePlantImage(this._service);

  final AiDiagnosisService _service;

  Future<PlantDiagnosisResult> call(XFile image) =>
      _service.analyzePlantImage(image);
}
