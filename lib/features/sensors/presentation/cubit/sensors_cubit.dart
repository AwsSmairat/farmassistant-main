import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/watch_sensors_dashboard.dart';
import '../mappers/sensors_ui_mapper.dart';
import 'sensors_state.dart';

class SensorsCubit extends Cubit<SensorsState> {
  SensorsCubit(this._watchSensorsDashboard) : super(const SensorsInitial());

  final WatchSensorsDashboard _watchSensorsDashboard;
  StreamSubscription? _sub;

  void start() {
    emit(const SensorsLoading());
    _sub?.cancel();
    _sub = _watchSensorsDashboard().listen(
      (snapshot) {
        emit(SensorsReady(
          snapshot: snapshot,
          tiles: SensorsUiMapper.tilesFrom(snapshot),
        ));
      },
      onError: (Object e, StackTrace st) {
        emit(SensorsFailure(
          e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
