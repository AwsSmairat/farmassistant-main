import 'package:equatable/equatable.dart';

/// How the model classified the plant for UI and Firestore mapping.
enum PlantDiagnosisCondition {
  /// Clearly healthy plant tissue.
  healthy,

  /// One or more diseases / stresses detected.
  diseased,

  /// Model did not find a disease signature (distinct copy from [healthy] in UI).
  noPathogenDetected,
}

/// Normalized output from [AiDiagnosisService] (cloud, mock, or composite).
class PlantDiagnosisResult extends Equatable {
  const PlantDiagnosisResult({
    required this.condition,
    required this.resultFirestoreLabel,
    required this.confidence,
    required this.treatmentAr,
    required this.analyzedAt,
    this.diseaseNameAr,
    this.diseaseName,
    this.explanation = '',
    this.persistedByCloud = false,
  });

  final PlantDiagnosisCondition condition;

  /// Stored in Firestore `result` (English labels keep compatibility with dashboard parsing).
  final String resultFirestoreLabel;

  /// 0..1
  final double confidence;

  final String treatmentAr;
  final DateTime analyzedAt;

  /// Arabic disease label when available (e.g. mock flow).
  final String? diseaseNameAr;

  /// English disease name from vision API / Cloud Function.
  final String? diseaseName;

  /// Short rationale from the model (may be English from API).
  final String explanation;

  /// When true, Firestore row was already written by Cloud Function — skip client save.
  final bool persistedByCloud;

  bool get isDiseased => condition == PlantDiagnosisCondition.diseased;

  bool get isNoPathogenDetected =>
      condition == PlantDiagnosisCondition.noPathogenDetected;

  /// Prefer Arabic, then English disease name for UI.
  String? get displayDiseaseName =>
      (diseaseNameAr?.trim().isNotEmpty ?? false)
          ? diseaseNameAr!.trim()
          : (diseaseName?.trim().isNotEmpty ?? false)
              ? diseaseName!.trim()
              : null;

  @override
  List<Object?> get props => [
        condition,
        resultFirestoreLabel,
        confidence,
        treatmentAr,
        analyzedAt,
        diseaseNameAr,
        diseaseName,
        explanation,
        persistedByCloud,
      ];
}
