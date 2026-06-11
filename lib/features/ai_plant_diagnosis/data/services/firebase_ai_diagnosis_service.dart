// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: firebase_ai_diagnosis_service.dart
// المسار: features/ai_plant_diagnosis/data/services/firebase_ai_diagnosis_service.dart
// الطبقة: data / services — خدمة بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. خدمة تنفيذ منطق أو اتصال خارجي.
//
// ماذا بداخله؟
//   • FirebaseAiDiagnosisService
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/failures/plant_diagnosis_failure.dart';
import '../../domain/services/ai_diagnosis_service.dart';
import '../datasources/ai_diagnosis_callable_datasource.dart';
import '../datasources/plant_image_upload_datasource.dart';
import '../mappers/plant_diagnosis_result_mapper.dart';
/// خدمة Firebase الذكاء الاصطناعي التشخيص.
class FirebaseAiDiagnosisService implements AiDiagnosisService {
  FirebaseAiDiagnosisService({
    required PlantImageUploadDatasource imageUpload,
    required AiDiagnosisCallableDatasource callable,
    FirebaseAuth? auth,
  })  : _imageUpload = imageUpload,
        _callable = callable,
        _auth = auth ?? FirebaseAuth.instance;

  /// حقل: الصورة رفع.
  final PlantImageUploadDatasource _imageUpload;
  /// حقل: استدعاء.
  final AiDiagnosisCallableDatasource _callable;
  /// حقل: المصادقة.
  final FirebaseAuth _auth;

  @override
  /// يحلّل النبات الصورة.
  Future<PlantDiagnosisResult> analyzePlantImage(XFile image) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        /// دالة النبات التشخيص فشل.
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
    /// دالة debug print.
      debugPrint('FirebaseAiDiagnosisService: $e\n$st');
      if (e.code == 'network-request-failed') {
        /// دالة النبات التشخيص فشل.
        throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.noInternet);
      }
      throw PlantDiagnosisFailure(PlantDiagnosisFailureReason.uploadFailed, technical: e);
    } catch (e, st) {
    /// دالة debug print.
      debugPrint('FirebaseAiDiagnosisService: $e\n$st');
      if (e is PlantDiagnosisFailure) rethrow;
      final msg = e.toString().toLowerCase();
      if (msg.contains('socketexception') ||
          msg.contains('failed host lookup') ||
          msg.contains('network is unreachable')) {
        /// دالة النبات التشخيص فشل.
        throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.noInternet);
      }
      throw PlantDiagnosisFailure(
        PlantDiagnosisFailureReason.cloudFunctionFailed,
        technical: e,
      );
    }
  }
}
