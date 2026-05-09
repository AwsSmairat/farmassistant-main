import 'package:equatable/equatable.dart';

/// One AI diagnosis row from Firestore `ai_diagnosis`.
class DiagnosisRecord extends Equatable {
  const DiagnosisRecord({
    required this.id,
    required this.resultName,
    required this.confidence,
    required this.suggestedTreatment,
    required this.imageUrl,
    required this.createdAt,
    required this.isHealthy,
  });

  final String id;
  final String resultName;
  final double confidence;
  final String suggestedTreatment;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isHealthy;

  @override
  List<Object?> get props =>
      [id, resultName, confidence, suggestedTreatment, imageUrl, createdAt, isHealthy];
}
