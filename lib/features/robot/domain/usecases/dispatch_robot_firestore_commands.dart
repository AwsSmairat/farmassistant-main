// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: dispatch_robot_firestore_commands.dart
// الطبقة: domain / usecases

// ماذا يفعل؟
//   طبقة حالة استخدام (Use Case) تغلف RobotCommandService
//   لتوفير واجهة نظيفة لإرسال أوامر الروبوت.

// ماذا بداخله؟
//   • DispatchRobotFirestoreCommands — الكلاس الرئيسي
//   • sendMove() — حركة: forward | backward | left | right | stop
//   • sendPump() — تشغيل/إيقاف المضخة
//   • sendAutoMode() — الوضع التلقائي
//   • requestGpsRefresh() — طلب تحديث GPS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import '../../data/services/robot_command_service.dart';

/// حالة استخدام: إرسال أوامر التحكم إلى robot_commands/{robotId} (دمج merge).
class DispatchRobotFirestoreCommands {
  DispatchRobotFirestoreCommands(this._commands);

  final RobotCommandService _commands;

  /// إرسال أمر حركة: forward | backward | left | right | stop.
  Future<void> sendMove(String direction) => _commands.sendMove(direction);

  /// تشغيل أو إيقاف مضخة المياه.
  Future<void> sendPump(bool on) => _commands.sendPump(on);

  /// تفعيل أو إلغاء الوضع التلقائي.
  Future<void> sendAutoMode(bool on) => _commands.sendAutoMode(on);

  /// طلب تحديث إحداثيات GPS من الروبوت.
  Future<void> requestGpsRefresh() => _commands.requestGpsRefresh();

  @Deprecated('استخدم sendMove للتحكم بالاتجاه')
  Future<void> sendServo(String direction) => sendMove(direction);

  @Deprecated('استخدم sendAutoMode بدلاً منه')
  Future<void> requestScan() => sendAutoMode(true);
}
