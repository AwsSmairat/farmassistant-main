// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: diagnosis_repository_impl.dart
// المسار: features/diagnosis/data/repositories/diagnosis_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: سجل تشخيص النبات. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • DiagnosisRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../../telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';
import '../../../telemetry/data/models/farm_firestore_models.dart';
import '../../domain/entities/diagnosis_record.dart';
import '../../domain/repositories/diagnosis_repository.dart';

/// تنفيذ مستودع التشخيص.
class DiagnosisRepositoryImpl implements DiagnosisRepository {
  DiagnosisRepositoryImpl(this._telemetry);

  /// حقل: البيانات.
  final FarmFirestoreTelemetryDatasource _telemetry;

  @override
  /// يراقب بثاً مباشراً لـ السجل.
  Stream<List<DiagnosisRecord>> watchHistory({int limit = 50}) {
    return _telemetry.watchAiDiagnosisDocs(limit: limit).map(_mapRows);
  }

  /// دالة داخلية: map rows.
  List<DiagnosisRecord> _mapRows(List<AiDiagnosisFirestoreDoc> rows) {
    return rows.map(_mapRow).toList();
  }

  /// دالة داخلية: map صف.
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

  /// دالة داخلية: infer healthy.
  static bool _inferHealthy(String result) {
    final s = result.toLowerCase();
    return s.contains('healthy') ||
        s.contains('سليم') ||
        s.contains('normal') ||
        s == 'ok';
  }
}
