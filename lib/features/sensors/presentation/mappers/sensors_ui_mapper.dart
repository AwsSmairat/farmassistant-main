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
      _temperature(s),
      _humidity(s),
      _waterLevel(s),
      _ph(s),
      _battery(s),
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

  static SensorTileVm _temperature(SensorsSnapshot s) {
    final t = s.temperatureCelsius;
    SensorHealth h = SensorHealth.good;
    if (t > 34 || t < 5) h = SensorHealth.warning;
    return SensorTileVm(
      title: 'درجة الحرارة',
      value: '${t.toStringAsFixed(1)}°C',
      icon: Icons.thermostat_outlined,
      health: h,
    );
  }

  static SensorTileVm _humidity(SensorsSnapshot s) {
    final v = s.humidityPercent;
    SensorHealth h = SensorHealth.good;
    if (v < 35 || v > 75) h = SensorHealth.warning;
    return SensorTileVm(
      title: 'رطوبة الهواء',
      value: '${v.toStringAsFixed(1)}%',
      icon: Icons.cloud_outlined,
      health: h,
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

  static SensorTileVm _ph(SensorsSnapshot s) {
    final p = s.ph;
    SensorHealth h;
    String? hint;
    if (p >= 6.0 && p <= 7.5) {
      h = SensorHealth.good;
    } else if (p >= 5.5 && p < 6.0 || p > 7.5 && p <= 8.0) {
      h = SensorHealth.warning;
      hint = 'قرب الحدود';
    } else {
      h = SensorHealth.critical;
      hint = 'قيمة pH خارج المدى الطبيعي';
    }
    return SensorTileVm(
      title: 'pH التربة',
      value: p.toStringAsFixed(1),
      icon: Icons.science_outlined,
      health: h,
      hint: hint,
    );
  }

  static SensorTileVm _battery(SensorsSnapshot s) {
    final b = s.batteryPercent;
    SensorHealth h;
    String? hint;
    if (b >= 40) {
      h = SensorHealth.good;
    } else if (b >= 20) {
      h = SensorHealth.warning;
      hint = 'شحن منخفض';
    } else {
      h = SensorHealth.critical;
      hint = 'البطارية منخفضة جداً';
    }
    return SensorTileVm(
      title: 'بطارية الروبوت',
      value: '${b.toStringAsFixed(0)}%',
      icon: Icons.battery_charging_full_outlined,
      health: h,
      hint: hint,
    );
  }
}
