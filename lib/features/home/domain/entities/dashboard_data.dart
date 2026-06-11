// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: dashboard_data.dart
// المسار: features/home/domain/entities/dashboard_data.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. جزء من ميزة الرئيسية ولوحة التحكم.
//
// ماذا بداخله؟
//   • DashboardData
//   • AiDiagnosis
//   • DashboardAlert
//   • DailyStats
//   • enum AlertPriority
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

import 'robot_mode.dart';
import 'robot_status.dart';
/// كلاس لوحة التحكم بيانات.
class DashboardData extends Equatable {
  /// دالة لوحة التحكم بيانات.
  const DashboardData({
    this.username,
    this.robotStatus = RobotStatus.unknown,
    this.robotMode = RobotMode.idle,
    this.batteryPercent,
    this.pumpOn,
    this.gpsOnline,
    this.waterTankLevelPercent,
    this.soilMoisturePercent,
    this.ph,
    this.ec,
    this.waterLevelPercent,
    this.temperatureCelsius,
    this.humidityPercent,
    this.latestAiDiagnosis,
    this.alerts = const [],
    this.dailyStats,
  });

  /// حقل: username.
  final String? username;
  /// حقل: الروبوت الحالة.
  final RobotStatus robotStatus;
  /// حقل: الروبوت وضع.
  final RobotMode robotMode;

  /// Robot telemetry.
  /// حقل: بطارية percent.
  final double? batteryPercent;
  /// حقل: مضخة on.
  final bool? pumpOn;
  /// حقل: GPS متصل.
  final bool? gpsOnline;
  /// حقل: مياه خزان مستوى percent.
  final double? waterTankLevelPercent;

  /// Sensor snapshot (latest readings).
  /// حقل: soil رطوبة percent.
  final double? soilMoisturePercent;
  /// حقل: ph.
  final double? ph;
  /// حقل: ec.
  final double? ec;
  /// حقل: مياه مستوى percent.
  final double? waterLevelPercent;
  /// حقل: temperature celsius.
  final double? temperatureCelsius;
  /// حقل: humidity percent.
  final double? humidityPercent;

  /// Latest AI diagnosis (best-effort, can be null).
  /// حقل: latest الذكاء الاصطناعي التشخيص.
  final AiDiagnosis? latestAiDiagnosis;

  /// Recent alerts (newest first).
  /// حقل: تنبيهات.
  final List<DashboardAlert> alerts;

  /// Daily statistics summary.
  /// حقل: daily stats.
  final DailyStats? dailyStats;

  @override
  /// يُرجع props.
  List<Object?> get props => [
        username,
        robotStatus,
        robotMode,
        batteryPercent,
        pumpOn,
        gpsOnline,
        waterTankLevelPercent,
        soilMoisturePercent,
        ph,
        ec,
        waterLevelPercent,
        temperatureCelsius,
        humidityPercent,
        latestAiDiagnosis,
        alerts,
        dailyStats,
      ];
}

/// كلاس الذكاء الاصطناعي التشخيص.
class AiDiagnosis extends Equatable {
  /// دالة الذكاء الاصطناعي التشخيص.
  const AiDiagnosis({
    required this.resultName,
    required this.confidence,
    required this.suggestedTreatment,
    required this.lastScanAt,
    required this.isHealthy,
  });

  /// حقل: نتيجة name.
  final String resultName; // Healthy or disease name
  /// حقل: confidence.
  final double confidence; // 0..1
  /// حقل: suggested treatment.
  final String suggestedTreatment;
  /// حقل: last scan at.
  final DateTime lastScanAt;
  /// حقل: is healthy.
  final bool isHealthy;

  @override
  /// يُرجع props.
  List<Object?> get props =>
      [resultName, confidence, suggestedTreatment, lastScanAt, isHealthy];
}

/// تعداد تنبيه priority.
enum AlertPriority { low, medium, high }

/// كلاس لوحة التحكم تنبيه.
class DashboardAlert extends Equatable {
  /// دالة لوحة التحكم تنبيه.
  const DashboardAlert({
    required this.title,
    required this.message,
    required this.priority,
    required this.time,
  });

  /// حقل: title.
  final String title;
  /// حقل: message.
  final String message;
  /// حقل: priority.
  final AlertPriority priority;
  /// حقل: time.
  final DateTime time;

  @override
  /// يُرجع props.
  List<Object?> get props => [title, message, priority, time];
}

/// كلاس daily stats.
class DailyStats extends Equatable {
  /// دالة daily stats.
  const DailyStats({
    required this.plantsScannedToday,
    required this.diseasesDetected,
    required this.healthyPlants,
    required this.lastScanTime,
  });

  /// حقل: plants scanned today.
  final int plantsScannedToday;
  /// حقل: diseases detected.
  final int diseasesDetected;
  /// حقل: healthy plants.
  final int healthyPlants;
  /// حقل: last scan time.
  final DateTime? lastScanTime;

  @override
  /// يُرجع props.
  List<Object?> get props =>
      [plantsScannedToday, diseasesDetected, healthyPlants, lastScanTime];
}
