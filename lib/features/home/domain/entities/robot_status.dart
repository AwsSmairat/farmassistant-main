// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_status.dart
// المسار: features/home/domain/entities/robot_status.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. جزء من ميزة الرئيسية ولوحة التحكم.
//
// ماذا بداخله؟
//   • enum RobotStatus
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// تعداد الروبوت الحالة.
enum RobotStatus {
  online,
  offline,
  unknown;

  String get displayName {
  /// دالة switch.
    switch (this) {
      case RobotStatus.online:
        return 'متصل';
      case RobotStatus.offline:
        return 'غير متصل';
      case RobotStatus.unknown:
        return '—';
    }
  }
}
