// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: watch_diagnosis_history.dart
// المسار: features/diagnosis/domain/usecases/watch_diagnosis_history.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: سجل تشخيص النبات. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • WatchDiagnosisHistory
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/diagnosis_record.dart';
import '../repositories/diagnosis_repository.dart';

/// كلاس مراقبة التشخيص السجل.
class WatchDiagnosisHistory {
  WatchDiagnosisHistory(this._repository);

  /// حقل: مستودع.
  final DiagnosisRepository _repository;

  /// دالة call.
  Stream<List<DiagnosisRecord>> call({int limit = 50}) =>
      _repository.watchHistory(limit: limit);
}
