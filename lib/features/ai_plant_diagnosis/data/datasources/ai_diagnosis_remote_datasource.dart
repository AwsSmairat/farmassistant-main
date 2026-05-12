import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../telemetry/data/firestore_paths.dart';
import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/failures/plant_diagnosis_failure.dart';
import 'plant_image_upload_datasource.dart';

/// Firestore writes for mock/offline client-side persistence (cloud path writes in CF).
class AiDiagnosisRemoteDatasource {
  AiDiagnosisRemoteDatasource({
    required PlantImageUploadDatasource imageUpload,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _imageUpload = imageUpload,
        _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final PlantImageUploadDatasource _imageUpload;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  Future<void> savePhoneUploadDiagnosis({
    required PlantDiagnosisResult result,
    required XFile image,
  }) async {
    final uid = _auth.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.notAuthenticated);
    }

    String imageUrl;
    try {
      imageUrl = await _imageUpload.uploadPhonePlantImage(image);
    } catch (e, st) {
      debugPrint('AiDiagnosisRemoteDatasource: upload $e\n$st');
      imageUrl = '';
    }

    await _db.collection(FarmFirestorePaths.aiDiagnosisCollection).add({
      'userId': uid,
      'robotId': FarmFirestorePaths.externalPhoneUploadRobotId,
      'source': 'phone_upload',
      'imageUrl': imageUrl,
      'result': result.resultFirestoreLabel,
      'diseaseName': result.diseaseName ?? result.diseaseNameAr ?? '',
      'confidence': result.confidence,
      'treatment': result.treatmentAr,
      'explanation': result.explanation,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
