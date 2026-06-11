// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_snapshot.dart
// المسار: features/sensors/domain/entities/sensors_snapshot.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. جزء من ميزة المستشعرات.
//
// ماذا بداخله؟
//   • SensorsSnapshot
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
/// كلاس المستشعرات لقطة.
class SensorsSnapshot extends Equatable {
  /// دالة المستشعرات لقطة.
  const SensorsSnapshot({
    required this.robotOnline,
    required this.latitude,
    required this.longitude,
    required this.soilMoisturePercent,
    required this.temperatureCelsius,
    required this.humidityPercent,
    required this.waterLevelPercent,
    required this.ph,
    required this.batteryPercent,
    required this.updatedAt,
  });

  /// حقل: الروبوت متصل.
  final bool robotOnline;
  /// حقل: latitude.
  final double latitude;
  /// حقل: longitude.
  final double longitude;
  /// حقل: soil رطوبة percent.
  final double soilMoisturePercent;
  /// حقل: temperature celsius.
  final double temperatureCelsius;
  /// حقل: humidity percent.
  final double humidityPercent;
  /// حقل: مياه مستوى percent.
  final double waterLevelPercent;
  /// حقل: ph.
  final double ph;
  /// حقل: بطارية percent.
  final double batteryPercent;
  /// حقل: updated at.
  final DateTime updatedAt;

  @override
  /// يُرجع props.
  List<Object?> get props => [
        robotOnline,
        latitude,
        longitude,
        soilMoisturePercent,
        temperatureCelsius,
        humidityPercent,
        waterLevelPercent,
        ph,
        batteryPercent,
        updatedAt,
      ];
}
