// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: diagnosis_repository.dart
// المسار: features/diagnosis/domain/repositories/diagnosis_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: سجل تشخيص النبات. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • DiagnosisRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/diagnosis_record.dart';

/// واجهة مستودع التشخيص.
abstract class DiagnosisRepository {
  /// يراقب بثاً مباشراً لـ السجل.
  Stream<List<DiagnosisRecord>> watchHistory({int limit});
}
