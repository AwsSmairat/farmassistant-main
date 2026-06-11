// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensor_health.dart
// المسار: features/sensors/domain/entities/sensor_health.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. جزء من ميزة المستشعرات.
//
// ماذا بداخله؟
//   • enum SensorHealth
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// تعداد المستشعر صحة.
enum SensorHealth {
  good,
  warning,
  critical,
}
