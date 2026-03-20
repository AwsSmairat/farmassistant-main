import 'dart:async';
import 'dart:math';

import '../../domain/entities/sensors_snapshot.dart';
import 'sensors_remote_datasource.dart';

/// MVP stream with realistic-ish values. Swap for Firebase `.snapshots()` later.
class SensorsRemoteDatasourceImpl implements SensorsRemoteDatasource {
  SensorsRemoteDatasourceImpl();

  final _random = Random();

  @override
  Stream<SensorsSnapshot> watchSensors() async* {
    var tick = 0;
    while (true) {
      yield _mockSnapshot(tick);
      tick++;
      await Future<void>.delayed(const Duration(seconds: 3));
    }
  }

  SensorsSnapshot _mockSnapshot(int tick) {
    final noise = _random.nextDouble() * 2 - 1;
    final latitude = 31.95 + sin(tick / 12) * 0.0012;
    final longitude = 35.93 + cos(tick / 12) * 0.0012;
    return SensorsSnapshot(
      robotOnline: true,
      latitude: latitude,
      longitude: longitude,
      soilMoisturePercent: (42 + noise * 3).clamp(18, 55),
      temperatureCelsius: (28 + noise * 0.8).clamp(22, 35),
      humidityPercent: (52 + noise * 4).clamp(35, 70),
      waterLevelPercent: (68 + sin(tick / 3) * 8).clamp(15, 95),
      ph: (6.6 + noise * 0.15).clamp(5.5, 8.2),
      batteryPercent: (82 - tick * 0.3).clamp(8, 100),
      updatedAt: DateTime.now(),
    );
  }
}
