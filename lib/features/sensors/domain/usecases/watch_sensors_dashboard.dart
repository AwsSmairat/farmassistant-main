// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: watch_sensors_dashboard.dart
// المسار: features/sensors/domain/usecases/watch_sensors_dashboard.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • WatchSensorsDashboard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/sensors_snapshot.dart';
import '../repositories/sensors_repository.dart';
/// كلاس مراقبة المستشعرات لوحة التحكم.
class WatchSensorsDashboard {
  WatchSensorsDashboard(this._repository);

  /// حقل: مستودع.
  final SensorsRepository _repository;

  /// دالة call.
  Stream<SensorsSnapshot> call() => _repository.watchSensors();
}
