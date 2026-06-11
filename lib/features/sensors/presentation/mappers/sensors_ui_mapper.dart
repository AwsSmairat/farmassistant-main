// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_ui_mapper.dart
// المسار: features/sensors/presentation/mappers/sensors_ui_mapper.dart
// الطبقة: presentation / mappers — تحويل للعرض
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. تحويل بين نماذج البيانات.
//
// ماذا بداخله؟
//   • SensorTileVm
//   • SensorsUiMapper
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/sensor_health.dart';
import '../../domain/entities/sensors_snapshot.dart';
/// كلاس المستشعر tile vm.
class SensorTileVm extends Equatable {
  /// دالة المستشعر tile vm.
  const SensorTileVm({
    required this.title,
    required this.value,
    required this.icon,
    required this.health,
    this.hint,
  });

  /// حقل: title.
  final String title;
  /// حقل: value.
  final String value;
  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: صحة.
  final SensorHealth health;
  /// حقل: hint.
  final String? hint;

  @override
  /// يُرجع props.
  List<Object?> get props => [title, value, icon, health, hint];
}

/// محوّل بيانات المستشعرات ui.
class SensorsUiMapper {
  /// دالة tiles from.
  static List<SensorTileVm> tilesFrom(SensorsSnapshot s) {
    return [
    /// دالة داخلية: soil رطوبة.
      _soilMoisture(s),
    /// دالة داخلية: مياه مستوى.
      _waterLevel(s),
    ];
  }

  /// دالة داخلية: soil رطوبة.
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


  /// دالة داخلية: مياه مستوى.
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
