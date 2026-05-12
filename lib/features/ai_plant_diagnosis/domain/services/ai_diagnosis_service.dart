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
/// `XFile(file.path)` before invoking the service.
abstract class AiDiagnosisService {
  Future<PlantDiagnosisResult> analyzePlantImage(XFile image);
}
