// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_diagnosis_callable_datasource.dart
// المسار: features/ai_plant_diagnosis/data/datasources/ai_diagnosis_callable_datasource.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. الاتصال بـ Firebase أو API.
//
// ماذا بداخله؟
//   • AiDiagnosisCallableDatasource
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../domain/failures/plant_diagnosis_failure.dart';

/// Calls the `analyzePlantImage` HTTPS callable (no secrets in the client).
///
/// [httpsCallableTimeout] is passed to [HttpsCallableOptions] only (SDK limit).
/// There is no extra client-side [Future.timeout] on the call so the request
/// مصدر بيانات الذكاء الاصطناعي التشخيص استدعاء مصدر بيانات.
class AiDiagnosisCallableDatasource {
  AiDiagnosisCallableDatasource({
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
    this.functionName = 'analyzePlantImage',
    this.httpsCallableTimeout = const Duration(hours: 24),
  })  : _functions = functions ?? FirebaseFunctions.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// حقل: functions.
  final FirebaseFunctions _functions;
  /// حقل: المصادقة.
  final FirebaseAuth _auth;
  /// حقل: function name.
  final String functionName;

  /// Upper bound for the callable HTTP client (not a second app-side cap).
  /// حقل: https استدعاء timeout.
  final Duration httpsCallableTimeout;

  /// Invokes Cloud Function with [imageUrl], signed-in [userId], and [source].
  /// يحلّل النبات الصورة.
  Future<Map<String, dynamic>> analyzePlantImage({
    required String imageUrl,
    required String userId,
    String source = 'phone_upload',
  }) async {
    if (_auth.currentUser?.uid != userId) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.notAuthenticated);
    }

    final callable = _functions.httpsCallable(
      functionName,
      options: HttpsCallableOptions(timeout: httpsCallableTimeout),
    );

    try {
      final result = await callable.call(<String, dynamic>{
        'imageUrl': imageUrl,
        'userId': userId,
        'source': source,
      });
      final raw = result.data;
      if (raw is! Map) {
        /// دالة النبات التشخيص فشل.
        throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.invalidAiResponse);
      }
      return Map<String, dynamic>.from(raw);
    } on FirebaseFunctionsException catch (e, st) {
    /// دالة debug print.
      debugPrint('AiDiagnosisCallableDatasource: ${e.code} ${e.message}\n$st');
      throw _mapFunctionsException(e);
    } catch (e, st) {
    /// دالة debug print.
      debugPrint('AiDiagnosisCallableDatasource: $e\n$st');
      if (e is PlantDiagnosisFailure) rethrow;
      throw PlantDiagnosisFailure(
        PlantDiagnosisFailureReason.cloudFunctionFailed,
        technical: e,
      );
    }
  }

  /// دالة داخلية: map functions استثناء.
  Never _mapFunctionsException(FirebaseFunctionsException e) {
  /// دالة switch.
    switch (e.code) {
      case 'not-found':
      case 'unimplemented':
        /// دالة النبات التشخيص فشل.
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionNotConfigured,
          technical: e,
        );
      case 'failed-precondition':
        /// دالة النبات التشخيص فشل.
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionNotConfigured,
          technical: e,
        );
      case 'invalid-argument':
        /// دالة النبات التشخيص فشل.
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.unsupportedImage,
          technical: e,
        );
      case 'deadline-exceeded':
        /// دالة النبات التشخيص فشل.
        throw const PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.analysisTimedOut,
        );
      case 'unavailable':
      case 'resource-exhausted':
        /// دالة النبات التشخيص فشل.
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionFailed,
          technical: e,
        );
      case 'unauthenticated':
        /// دالة النبات التشخيص فشل.
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.notAuthenticated,
          technical: e,
        );
      default:
        /// دالة النبات التشخيص فشل.
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionFailed,
          technical: e,
        );
    }
  }
}
