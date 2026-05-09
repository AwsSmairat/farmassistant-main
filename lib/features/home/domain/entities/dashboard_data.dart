import 'package:equatable/equatable.dart';

import 'robot_mode.dart';
import 'robot_status.dart';

/// Dashboard data for the home screen (username, robot status, last sensor readings).
class DashboardData extends Equatable {
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

  final String? username;
  final RobotStatus robotStatus;
  final RobotMode robotMode;

  /// Robot telemetry.
  final double? batteryPercent;
  final bool? pumpOn;
  final bool? gpsOnline;
  final double? waterTankLevelPercent;

  /// Sensor snapshot (latest readings).
  final double? soilMoisturePercent;
  final double? ph;
  final double? ec;
  final double? waterLevelPercent;
  final double? temperatureCelsius;
  final double? humidityPercent;

  /// Latest AI diagnosis (best-effort, can be null).
  final AiDiagnosis? latestAiDiagnosis;

  /// Recent alerts (newest first).
  final List<DashboardAlert> alerts;

  /// Daily statistics summary.
  final DailyStats? dailyStats;

  @override
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

class AiDiagnosis extends Equatable {
  const AiDiagnosis({
    required this.resultName,
    required this.confidence,
    required this.suggestedTreatment,
    required this.lastScanAt,
    required this.isHealthy,
  });

  final String resultName; // Healthy or disease name
  final double confidence; // 0..1
  final String suggestedTreatment;
  final DateTime lastScanAt;
  final bool isHealthy;

  @override
  List<Object?> get props =>
      [resultName, confidence, suggestedTreatment, lastScanAt, isHealthy];
}

enum AlertPriority { low, medium, high }

class DashboardAlert extends Equatable {
  const DashboardAlert({
    required this.title,
    required this.message,
    required this.priority,
    required this.time,
  });

  final String title;
  final String message;
  final AlertPriority priority;
  final DateTime time;

  @override
  List<Object?> get props => [title, message, priority, time];
}

class DailyStats extends Equatable {
  const DailyStats({
    required this.plantsScannedToday,
    required this.diseasesDetected,
    required this.healthyPlants,
    required this.lastScanTime,
  });

  final int plantsScannedToday;
  final int diseasesDetected;
  final int healthyPlants;
  final DateTime? lastScanTime;

  @override
  List<Object?> get props =>
      [plantsScannedToday, diseasesDetected, healthyPlants, lastScanTime];
}
