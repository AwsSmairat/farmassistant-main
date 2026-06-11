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
