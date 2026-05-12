import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/failures/plant_diagnosis_failure.dart';
import '../../domain/services/ai_diagnosis_service.dart';
import '../datasources/ai_diagnosis_callable_datasource.dart';
import '../datasources/plant_image_upload_datasource.dart';
import '../mappers/plant_diagnosis_result_mapper.dart';

/// Real pipeline: Storage → callable `analyzePlantImage` → parsed result (Firestore written in CF).
class FirebaseAiDiagnosisService implements AiDiagnosisService {
  FirebaseAiDiagnosisService({
    required PlantImageUploadDatasource imageUpload,
    required AiDiagnosisCallableDatasource callable,
    FirebaseAuth? auth,
  })  : _imageUpload = imageUpload,
        _callable = callable,
        _auth = auth ?? FirebaseAuth.instance;

  final PlantImageUploadDatasource _imageUpload;
  final AiDiagnosisCallableDatasource _callable;
  final FirebaseAuth _auth;

  @override
  Future<PlantDiagnosisResult> analyzePlantImage(XFile image) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.notAuthenticated);
      }

      final imageUrl = await _imageUpload.uploadPhonePlantImage(image);
      final map = await _callable.analyzePlantImage(
        imageUrl: imageUrl,
        userId: uid,
        source: 'phone_upload',
      );
      return PlantDiagnosisResultMapper.fromCallableMap(map);
    } on PlantDiagnosisFailure {
      rethrow;
    } on FirebaseException catch (e, st) {
      debugPrint('FirebaseAiDiagnosisService: $e\n$st');
      if (e.code == 'network-request-failed') {
        throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.noInternet);
      }
      throw PlantDiagnosisFailure(PlantDiagnosisFailureReason.uploadFailed, technical: e);
    } catch (e, st) {
      debugPrint('FirebaseAiDiagnosisService: $e\n$st');
      if (e is PlantDiagnosisFailure) rethrow;
      final msg = e.toString().toLowerCase();
      if (msg.contains('socketexception') ||
          msg.contains('failed host lookup') ||
          msg.contains('network is unreachable')) {
        throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.noInternet);
      }
      throw PlantDiagnosisFailure(
        PlantDiagnosisFailureReason.cloudFunctionFailed,
        technical: e,
      );
    }
  }
}
