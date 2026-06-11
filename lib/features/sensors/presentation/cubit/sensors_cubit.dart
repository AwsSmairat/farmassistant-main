// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_cubit.dart
// المسار: features/sensors/presentation/cubit/sensors_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • SensorsCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/watch_sensors_dashboard.dart';
import '../mappers/sensors_ui_mapper.dart';
import 'sensors_state.dart';

/// منطق الواجهة (Cubit) لـ المستشعرات.
class SensorsCubit extends Cubit<SensorsState> {
  SensorsCubit(this._watchSensorsDashboard) : super(const SensorsInitial());

  /// حقل: مراقبة المستشعرات لوحة التحكم.
  final WatchSensorsDashboard _watchSensorsDashboard;
  StreamSubscription? _sub;

  /// يبدأ.
  void start() {
  /// يصدّر حالة جديدة.
    emit(const SensorsLoading());
    _sub?.cancel();
    _sub = _watchSensorsDashboard().listen(
      (snapshot) {
        emit(SensorsReady(
          snapshot: snapshot,
          tiles: SensorsUiMapper.tilesFrom(snapshot),
          isCheckingSoilMoisture: false,
          isMonitoringEnabled: true,
        ));
      },
      onError: (Object e, StackTrace st) {
        emit(SensorsFailure(
          e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
        ));
      },
    );
  }

  /// يبدّل monitoring.
  void toggleMonitoring() {
    final current = state;
    if (current is! SensorsReady) return;

    if (current.isMonitoringEnabled) {
      _sub?.cancel();
      _sub = null;
      emit(SensorsReady(
        snapshot: current.snapshot,
        tiles: current.tiles,
        isCheckingSoilMoisture: false,
        isMonitoringEnabled: false,
      ));
      return;
    }

  /// يبدأ.
    start();
  }

  /// دالة check soil رطوبة.
  Future<void> checkSoilMoisture() async {
    final current = state;
    if (current is! SensorsReady) return;

  /// يصدّر حالة جديدة.
    emit(SensorsReady(
      snapshot: current.snapshot,
      tiles: current.tiles,
      isCheckingSoilMoisture: true,
      isMonitoringEnabled: current.isMonitoringEnabled,
    ));

    try {
      final snapshot = await _watchSensorsDashboard().first;
      emit(SensorsReady(
        snapshot: snapshot,
        tiles: SensorsUiMapper.tilesFrom(snapshot),
        isCheckingSoilMoisture: false,
        isMonitoringEnabled: current.isMonitoringEnabled,
      ));
    } catch (e, _) {
      emit(SensorsFailure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }

  @override
  /// يغلق.
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
