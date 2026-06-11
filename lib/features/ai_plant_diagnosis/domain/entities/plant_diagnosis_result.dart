// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: plant_diagnosis_result.dart
// المسار: features/ai_plant_diagnosis/domain/entities/plant_diagnosis_result.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. جزء من ميزة تشخيص النبات بالذكاء الاصطناعي.
//
// ماذا بداخله؟
//   • PlantDiagnosisResult
//   • enum PlantDiagnosisCondition
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
/// تعداد النبات التشخيص condition.
enum PlantDiagnosisCondition {
  /// Clearly healthy plant tissue.
  healthy,

  /// One or more diseases / stresses detected.
  diseased,

  /// Model did not find a disease signature (distinct copy from [healthy] in UI).
  noPathogenDetected,
}
/// كلاس النبات التشخيص نتيجة.
class PlantDiagnosisResult extends Equatable {
  /// دالة النبات التشخيص نتيجة.
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

  /// حقل: condition.
  final PlantDiagnosisCondition condition;

  /// Stored in Firestore `result` (English labels keep compatibility with dashboard parsing).
  /// حقل: نتيجة Firestore label.
  final String resultFirestoreLabel;

  /// 0..1
  /// حقل: confidence.
  final double confidence;

  /// حقل: treatment ar.
  final String treatmentAr;
  /// حقل: analyzed at.
  final DateTime analyzedAt;

  /// Arabic disease label when available (e.g. mock flow).
  /// حقل: disease name ar.
  final String? diseaseNameAr;

  /// English disease name from vision API / Cloud Function.
  /// حقل: disease name.
  final String? diseaseName;

  /// Short rationale from the model (may be English from API).
  /// حقل: explanation.
  final String explanation;

  /// When true, Firestore row was already written by Cloud Function — skip client save.
  /// حقل: persisted by cloud.
  final bool persistedByCloud;

  /// يُرجع is diseased.
  bool get isDiseased => condition == PlantDiagnosisCondition.diseased;

  /// يُرجع is no pathogen detected.
  bool get isNoPathogenDetected =>
      condition == PlantDiagnosisCondition.noPathogenDetected;

  /// Prefer Arabic, then English disease name for UI.
  /// يُرجع display disease name.
  String? get displayDiseaseName =>
      (diseaseNameAr?.trim().isNotEmpty ?? false)
          ? diseaseNameAr!.trim()
          : (diseaseName?.trim().isNotEmpty ?? false)
              ? diseaseName!.trim()
              : null;

  @override
  /// يُرجع props.
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
