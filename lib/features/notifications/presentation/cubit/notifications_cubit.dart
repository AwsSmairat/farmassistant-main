// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: notifications_cubit.dart
// المسار: features/notifications/presentation/cubit/notifications_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • NotificationsCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/clear_all_notifications.dart';
import '../../domain/usecases/delete_notification.dart';
import '../../domain/usecases/mark_notification_read.dart';
import '../../domain/usecases/watch_notifications.dart';
import 'notifications_state.dart';

/// منطق الواجهة (Cubit) لـ التنبيهات.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(
    this._watchNotifications,
    this._markNotificationRead,
    this._deleteNotification,
    this._clearAllNotifications,
  ) : super(const NotificationsInitial());

  /// حقل: مراقبة التنبيهات.
  final WatchNotifications _watchNotifications;
  /// حقل: تعليم التنبيه مقروء.
  final MarkNotificationRead _markNotificationRead;
  /// حقل: حذف التنبيه.
  final DeleteNotification _deleteNotification;
  /// حقل: مسح all التنبيهات.
  final ClearAllNotifications _clearAllNotifications;

  StreamSubscription? _sub;

  /// يبدأ.
  void start() {
    if (_sub != null) return;
  /// يصدّر حالة جديدة.
    emit(const NotificationsLoading());
    _sub = _watchNotifications().listen(
      (items) => emit(NotificationsReady(items)),
      onError: (error, _) => emit(
      /// دالة التنبيهات فشل.
        NotificationsFailure(
          error is Exception
              ? error.toString().replaceFirst('Exception: ', '')
              : error.toString(),
        ),
      ),
    );
  }

  /// يعلّم as مقروء.
  Future<void> markAsRead(String id) {
    return _markNotificationRead(id);
  }

  /// يحذف by id.
  Future<void> deleteById(String id) {
    return _deleteNotification(id);
  }

  /// يمسح all.
  Future<void> clearAll() {
    return _clearAllNotifications();
  }

  @override
  /// يغلق.
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
