// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_state.dart
// المسار: features/sensors/presentation/cubit/sensors_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • sensors_state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

import '../../domain/entities/sensors_snapshot.dart';
import '../mappers/sensors_ui_mapper.dart';

sealed class SensorsState extends Equatable {
  /// دالة المستشعرات الحالة.
  const SensorsState();

  @override
  /// يُرجع props.
  List<Object?> get props => [];
}

final class SensorsInitial extends SensorsState {
  /// دالة المستشعرات initial.
  const SensorsInitial();
}

final class SensorsLoading extends SensorsState {
  /// دالة المستشعرات تحميل.
  const SensorsLoading();
}

final class SensorsReady extends SensorsState {
  /// دالة المستشعرات ready.
  const SensorsReady({
    required this.snapshot,
    required this.tiles,
    this.isCheckingSoilMoisture = false,
    this.isMonitoringEnabled = true,
  });

  /// حقل: لقطة.
  final SensorsSnapshot snapshot;
  /// حقل: tiles.
  final List<SensorTileVm> tiles;
  /// حقل: is checking soil رطوبة.
  final bool isCheckingSoilMoisture;
  /// حقل: is monitoring enabled.
  final bool isMonitoringEnabled;

  @override
  /// يُرجع props.
  List<Object?> get props => [snapshot, tiles, isCheckingSoilMoisture, isMonitoringEnabled];
}

final class SensorsFailure extends SensorsState {
  /// دالة المستشعرات فشل.
  const SensorsFailure(this.message);

  /// حقل: message.
  final String message;

  @override
  /// يُرجع props.
  List<Object?> get props => [message];
}
