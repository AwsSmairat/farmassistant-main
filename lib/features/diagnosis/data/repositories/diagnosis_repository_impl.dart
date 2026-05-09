import '../../../telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';
import '../../../telemetry/data/models/farm_firestore_models.dart';
import '../../domain/entities/diagnosis_record.dart';
import '../../domain/repositories/diagnosis_repository.dart';

class DiagnosisRepositoryImpl implements DiagnosisRepository {
  DiagnosisRepositoryImpl(this._telemetry);

  final FarmFirestoreTelemetryDatasource _telemetry;

  @override
  Stream<List<DiagnosisRecord>> watchHistory({int limit = 50}) {
    return _telemetry.watchAiDiagnosisDocs(limit: limit).map(_mapRows);
  }

  List<DiagnosisRecord> _mapRows(List<AiDiagnosisFirestoreDoc> rows) {
    return rows.map(_mapRow).toList();
  }

  DiagnosisRecord _mapRow(AiDiagnosisFirestoreDoc row) {
    final confRaw = row.confidence;
    final confidence01 = confRaw == null
        ? 0.0
        : confRaw > 1
            ? (confRaw / 100).clamp(0.0, 1.0)
            : confRaw.clamp(0.0, 1.0);
    final result = row.result?.trim().isNotEmpty == true ? row.result!.trim() : '—';
    final treatment =
        row.treatment?.trim().isNotEmpty == true ? row.treatment!.trim() : '—';
    final healthy = _inferHealthy(result);
    return DiagnosisRecord(
      id: row.id,
      resultName: result,
      confidence: confidence01,
      suggestedTreatment: treatment,
      imageUrl: row.imageUrl,
      createdAt: row.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      isHealthy: healthy,
    );
  }

  static bool _inferHealthy(String result) {
    final s = result.toLowerCase();
    return s.contains('healthy') ||
        s.contains('سليم') ||
        s.contains('normal') ||
        s == 'ok';
  }
}
