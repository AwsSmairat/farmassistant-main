import 'package:equatable/equatable.dart';

import '../../domain/entities/sensors_snapshot.dart';
import '../mappers/sensors_ui_mapper.dart';

sealed class SensorsState extends Equatable {
  const SensorsState();

  @override
  List<Object?> get props => [];
}

final class SensorsInitial extends SensorsState {
  const SensorsInitial();
}

final class SensorsLoading extends SensorsState {
  const SensorsLoading();
}

final class SensorsReady extends SensorsState {
  const SensorsReady({
    required this.snapshot,
    required this.tiles,
    this.isCheckingSoilMoisture = false,
    this.isMonitoringEnabled = true,
  });

  final SensorsSnapshot snapshot;
  final List<SensorTileVm> tiles;
  final bool isCheckingSoilMoisture;
  final bool isMonitoringEnabled;

  @override
  List<Object?> get props => [snapshot, tiles, isCheckingSoilMoisture, isMonitoringEnabled];
}

final class SensorsFailure extends SensorsState {
  const SensorsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
