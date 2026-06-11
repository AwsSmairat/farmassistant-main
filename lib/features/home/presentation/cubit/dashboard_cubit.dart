// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: dashboard_cubit.dart
// المسار: features/home/presentation/cubit/dashboard_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • DashboardCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dashboard_data.dart';
import '../../domain/usecases/watch_dashboard_data.dart';
import 'dashboard_state.dart';

/// منطق الواجهة (Cubit) لـ لوحة التحكم.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._watchDashboardData) : super(const DashboardInitial());

  /// حقل: مراقبة لوحة التحكم بيانات.
  final WatchDashboardData _watchDashboardData;
  StreamSubscription<DashboardData>? _sub;

  /// دالة load.
  void load() {
  /// يصدّر حالة جديدة.
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
  /// يغلق.
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
