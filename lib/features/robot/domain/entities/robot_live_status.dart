// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_live_status.dart
// الطبقة: domain / entities

// ماذا يفعل؟
//   يمثل شكل بيانات حالة الروبوت كما تأتي من Firestore
//   (مستند robot_status/robot_001).

// ماذا بداخله؟
//   • RobotLiveStatus — كيان الحالة مع الحقول:
//     online, battery, tankLevel, moisture, gpsLabel,
//     currentMove, pump, autoMode, cameraUrl, exists
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:equatable/equatable.dart';

/// لقطة حالة الروبوت من مستند Firestore: robot_status/{robotId}.
class RobotLiveStatus extends Equatable {
  const RobotLiveStatus({
    this.online = false,
    this.battery,
    this.tankLevel,
    this.moisture,
    this.gpsLabel,
    this.currentMove,
    this.pump,
    this.autoMode,
    this.cameraUrl,
    this.exists = false,
  });

  /// هل الروبوت متصل حالياً؟
  final bool online;

  /// مستوى البطارية (نسبة مئوية).
  final double? battery;

  /// مستوى خزان المياه.
  final double? tankLevel;

  /// رطوبة التربة.
  final double? moisture;

  /// نص إحداثيات GPS جاهز للعرض.
  final String? gpsLabel;

  /// آخر أمر حركة (forward, backward, left, right, stop).
  final String? currentMove;

  /// حالة مضخة المياه.
  final bool? pump;

  /// هل الوضع التلقائي مفعّل؟
  final bool? autoMode;

  /// رابط بث الكاميرا MJPEG من الراسبيري باي.
  final String? cameraUrl;

  /// هل يوجد مستند الحالة في Firestore؟
  final bool exists;

  @override
  List<Object?> get props => [
        online,
        battery,
        tankLevel,
        moisture,
        gpsLabel,
        currentMove,
        pump,
        autoMode,
        cameraUrl,
        exists,
      ];
}
