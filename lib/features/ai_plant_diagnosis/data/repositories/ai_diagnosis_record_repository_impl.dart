import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/repositories/ai_diagnosis_record_repository.dart';
import '../datasources/ai_diagnosis_remote_datasource.dart';

class AiDiagnosisRecordRepositoryImpl implements AiDiagnosisRecordRepository {
  AiDiagnosisRecordRepositoryImpl(this._remote);

  final AiDiagnosisRemoteDatasource _remote;

  @override
  Future<void> saveAppUploadDiagnosis({
    required PlantDiagnosisResult result,
    required XFile image,
  }) {
    return _remote.savePhoneUploadDiagnosis(result: result, image: image);
  }
}
