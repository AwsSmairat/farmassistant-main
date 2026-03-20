import 'package:equatable/equatable.dart';

/// Raw sensor readings from backend (Firebase / IoT). Presentation maps to tiles + health.
class SensorsSnapshot extends Equatable {
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

  final bool robotOnline;
  final double latitude;
  final double longitude;
  final double soilMoisturePercent;
  final double temperatureCelsius;
  final double humidityPercent;
  final double waterLevelPercent;
  final double ph;
  final double batteryPercent;
  final DateTime updatedAt;

  @override
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
