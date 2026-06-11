// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: dashboard_state.dart
// المسار: features/home/presentation/cubit/dashboard_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • dashboard_state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

import '../../domain/entities/dashboard_data.dart';

sealed class DashboardState extends Equatable {
  /// دالة لوحة التحكم الحالة.
  const DashboardState();

  @override
  /// يُرجع props.
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  /// دالة لوحة التحكم initial.
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  /// دالة لوحة التحكم تحميل.
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  /// دالة لوحة التحكم loaded.
  const DashboardLoaded(this.data);

  /// حقل: بيانات.
  final DashboardData data;

  @override
  /// يُرجع props.
  List<Object?> get props => [data];
}

final class DashboardFailure extends DashboardState {
  /// دالة لوحة التحكم فشل.
  const DashboardFailure(this.message);

  /// حقل: message.
  final String message;

  @override
  /// يُرجع props.
  List<Object?> get props => [message];
}
