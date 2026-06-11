// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_mode.dart
// المسار: features/home/domain/entities/robot_mode.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. جزء من ميزة الرئيسية ولوحة التحكم.
//
// ماذا بداخله؟
//   • enum RobotMode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// تعداد الروبوت وضع.
enum RobotMode {
  idle,
  moving,
  scanning,
  spraying;

  String get displayName {
  /// دالة switch.
    switch (this) {
      case RobotMode.idle:
        return 'خامل';
      case RobotMode.moving:
        return 'يتحرك';
      case RobotMode.scanning:
        return 'يفحص';
      case RobotMode.spraying:
        return 'يرش';
    }
  }
}

