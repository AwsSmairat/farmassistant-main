// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: notifications_state.dart
// المسار: features/notifications/presentation/cubit/notifications_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • notifications_state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

import '../../domain/entities/farm_notification.dart';

sealed class NotificationsState extends Equatable {
  /// دالة التنبيهات الحالة.
  const NotificationsState();

  @override
  /// يُرجع props.
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  /// دالة التنبيهات initial.
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  /// دالة التنبيهات تحميل.
  const NotificationsLoading();
}

final class NotificationsReady extends NotificationsState {
  /// دالة التنبيهات ready.
  const NotificationsReady(this.items);

  /// حقل: items.
  final List<FarmNotification> items;

  @override
  /// يُرجع props.
  List<Object?> get props => [items];
}

final class NotificationsFailure extends NotificationsState {
  /// دالة التنبيهات فشل.
  const NotificationsFailure(this.message);

  /// حقل: message.
  final String message;

  @override
  /// يُرجع props.
  List<Object?> get props => [message];
}
