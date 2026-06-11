// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: diagnosis_record.dart
// المسار: features/diagnosis/domain/entities/diagnosis_record.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: سجل تشخيص النبات. جزء من ميزة سجل تشخيص النبات.
//
// ماذا بداخله؟
//   • DiagnosisRecord
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
/// كلاس التشخيص سجل.
class DiagnosisRecord extends Equatable {
  /// دالة التشخيص سجل.
  const DiagnosisRecord({
    required this.id,
    required this.resultName,
    required this.confidence,
    required this.suggestedTreatment,
    required this.imageUrl,
    required this.createdAt,
    required this.isHealthy,
  });

  /// حقل: id.
  final String id;
  /// حقل: نتيجة name.
  final String resultName;
  /// حقل: confidence.
  final double confidence;
  /// حقل: suggested treatment.
  final String suggestedTreatment;
  /// حقل: الصورة url.
  final String? imageUrl;
  /// حقل: created at.
  final DateTime createdAt;
  /// حقل: is healthy.
  final bool isHealthy;

  @override
  /// يُرجع props.
  List<Object?> get props =>
      [id, resultName, confidence, suggestedTreatment, imageUrl, createdAt, isHealthy];
}
