import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_dashboard_data.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getDashboardData) : super(const DashboardInitial());

  final GetDashboardData _getDashboardData;

  Future<void> load() async {
    emit(const DashboardLoading());
    try {
      final data = await _getDashboardData();
      emit(DashboardLoaded(data));
    } catch (e, _) {
      emit(DashboardFailure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }
}
