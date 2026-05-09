import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/sensor_health.dart';
import '../../domain/entities/sensors_snapshot.dart';

/// Maps raw readings to card view models. Status colors apply only to card accents.
class SensorTileVm extends Equatable {
  const SensorTileVm({
    required this.title,
    required this.value,
    required this.icon,
    required this.health,
    this.hint,
  });

  final String title;
  final String value;
  final IconData icon;
  final SensorHealth health;
  final String? hint;

  @override
  List<Object?> get props => [title, value, icon, health, hint];
}

class SensorsUiMapper {
  static List<SensorTileVm> tilesFrom(SensorsSnapshot s) {
    return [
      _soilMoisture(s),
      _waterLevel(s),
    ];
  }

  static SensorTileVm _soilMoisture(SensorsSnapshot s) {
    final v = s.soilMoisturePercent;
    SensorHealth h;
    String? hint;
    if (v >= 40) {
      h = SensorHealth.good;
    } else if (v >= 25) {
      h = SensorHealth.warning;
      hint = 'الرطوبة متوسطة';
    } else {
      h = SensorHealth.critical;
      hint = 'تربة جافة — راجع الري';
    }
    return SensorTileVm(
      title: 'رطوبة التربة',
      value: '${v.toStringAsFixed(1)}%',
      icon: Icons.water_drop_outlined,
      health: h,
      hint: hint,
    );
  }


  static SensorTileVm _waterLevel(SensorsSnapshot s) {
    final v = s.waterLevelPercent;
    SensorHealth h;
    String? hint;
    if (v >= 40) {
      h = SensorHealth.good;
    } else if (v >= 20) {
      h = SensorHealth.warning;
      hint = 'مستوى الماء منخفض';
    } else {
      h = SensorHealth.critical;
      hint = 'تحذير: الخزان شبه فارغ';
    }
    return SensorTileVm(
      title: 'مستوى الماء',
      value: '${v.toStringAsFixed(0)}%',
      icon: Icons.opacity_outlined,
      health: h,
      hint: hint,
    );
  }

}
