import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dashboard_data.dart';
import '../../domain/usecases/watch_dashboard_data.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._watchDashboardData) : super(const DashboardInitial());

  final WatchDashboardData _watchDashboardData;
  StreamSubscription<DashboardData>? _sub;

  void load() {
    emit(const DashboardLoading());
    _sub?.cancel();
    _sub = _watchDashboardData().listen(
      (data) => emit(DashboardLoaded(data)),
      onError: (Object e, _) {
        emit(DashboardFailure(
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
