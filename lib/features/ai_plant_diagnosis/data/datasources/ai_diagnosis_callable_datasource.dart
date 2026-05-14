import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../domain/failures/plant_diagnosis_failure.dart';

/// Calls the `analyzePlantImage` HTTPS callable (no secrets in the client).
class AiDiagnosisCallableDatasource {
  AiDiagnosisCallableDatasource({
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
    this.functionName = 'analyzePlantImage',
    this.timeout = const Duration(seconds: 165),
  })  : _functions = functions ?? FirebaseFunctions.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;
  final String functionName;
  final Duration timeout;

  /// Invokes Cloud Function with [imageUrl], signed-in [userId], and [source].
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
      options: HttpsCallableOptions(timeout: timeout),
    );

    try {
      final result = await callable
          .call(<String, dynamic>{
            'imageUrl': imageUrl,
            'userId': userId,
            'source': source,
          })
          .timeout(
            timeout,
            onTimeout: () => throw const PlantDiagnosisFailure(
              PlantDiagnosisFailureReason.analysisTimedOut,
            ),
          );
      final raw = result.data;
      if (raw is! Map) {
        throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.invalidAiResponse);
      }
      return Map<String, dynamic>.from(raw);
    } on FirebaseFunctionsException catch (e, st) {
      debugPrint('AiDiagnosisCallableDatasource: ${e.code} ${e.message}\n$st');
      throw _mapFunctionsException(e);
    } catch (e, st) {
      debugPrint('AiDiagnosisCallableDatasource: $e\n$st');
      if (e is PlantDiagnosisFailure) rethrow;
      throw PlantDiagnosisFailure(
        PlantDiagnosisFailureReason.cloudFunctionFailed,
        technical: e,
      );
    }
  }

  Never _mapFunctionsException(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'not-found':
      case 'unimplemented':
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionNotConfigured,
          technical: e,
        );
      case 'failed-precondition':
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionNotConfigured,
          technical: e,
        );
      case 'invalid-argument':
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.unsupportedImage,
          technical: e,
        );
      case 'deadline-exceeded':
        throw const PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.analysisTimedOut,
        );
      case 'unavailable':
      case 'resource-exhausted':
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionFailed,
          technical: e,
        );
      case 'unauthenticated':
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.notAuthenticated,
          technical: e,
        );
      default:
        throw PlantDiagnosisFailure(
          PlantDiagnosisFailureReason.cloudFunctionFailed,
          technical: e,
        );
    }
  }
}
