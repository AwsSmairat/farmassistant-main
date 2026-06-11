// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: plant_diagnosis_result_mapper.dart
// المسار: features/ai_plant_diagnosis/data/mappers/plant_diagnosis_result_mapper.dart
// الطبقة: data / mappers — تحويل البيانات
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. تحويل بين نماذج البيانات.
//
// ماذا بداخله؟
//   • PlantDiagnosisResultMapper
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/failures/plant_diagnosis_failure.dart';
/// محوّل بيانات النبات التشخيص نتيجة.
class PlantDiagnosisResultMapper {
  PlantDiagnosisResultMapper._();

  /// دالة from استدعاء map.
  static PlantDiagnosisResult fromCallableMap(Map<String, dynamic> raw) {
    final resultStr = (raw['result'] ?? '').toString().trim();
    final diseaseName = (raw['diseaseName'] ?? '').toString().trim();
    final confRaw = raw['confidence'];
    double conf;
    if (confRaw is num) {
      conf = confRaw.toDouble();
    } else {
      conf = double.tryParse('$confRaw') ?? 0;
    }
    if (conf > 1) conf = (conf / 100).clamp(0.0, 1.0);
    conf = conf.clamp(0.0, 1.0);

    final treatment = (raw['treatment'] ?? '').toString().trim();
    final explanation = (raw['explanation'] ?? '').toString().trim();
    final diagnosedAtRaw = raw['diagnosedAt']?.toString();
    final analyzedAt = diagnosedAtRaw != null && diagnosedAtRaw.isNotEmpty
        ? (DateTime.tryParse(diagnosedAtRaw) ?? DateTime.now())
        : DateTime.now();

    final lower = resultStr.toLowerCase();
    final isHealthy = lower == 'healthy' || lower == 'ok' || lower == 'normal';

    PlantDiagnosisCondition condition;
    if (isHealthy) {
      condition = PlantDiagnosisCondition.healthy;
    } else if (lower == 'diseased' || diseaseName.isNotEmpty) {
      condition = PlantDiagnosisCondition.diseased;
    } else {
      condition = PlantDiagnosisCondition.noPathogenDetected;
    }

    final firestoreResult = isHealthy
        ? 'Healthy'
        : (diseaseName.isNotEmpty ? diseaseName : (resultStr.isNotEmpty ? resultStr : 'Diseased'));

    if (resultStr.isEmpty) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.invalidAiResponse);
    }

    return PlantDiagnosisResult(
      condition: condition,
      resultFirestoreLabel: firestoreResult,
      confidence: conf,
      treatmentAr: treatment.isEmpty ? '—' : treatment,
      analyzedAt: analyzedAt,
      diseaseName: diseaseName.isEmpty ? null : diseaseName,
      explanation: explanation,
      persistedByCloud: true,
    );
  }
}
