// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_repository.dart
// المسار: features/sensors/domain/repositories/sensors_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • SensorsRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/sensors_snapshot.dart';
/// واجهة مستودع المستشعرات.
abstract class SensorsRepository {
  /// يراقب بثاً مباشراً لـ المستشعرات.
  Stream<SensorsSnapshot> watchSensors();
}
