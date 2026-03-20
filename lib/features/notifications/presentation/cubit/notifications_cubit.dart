import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/clear_all_notifications.dart';
import '../../domain/usecases/delete_notification.dart';
import '../../domain/usecases/mark_notification_read.dart';
import '../../domain/usecases/watch_notifications.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(
    this._watchNotifications,
    this._markNotificationRead,
    this._deleteNotification,
    this._clearAllNotifications,
  ) : super(const NotificationsInitial());

  final WatchNotifications _watchNotifications;
  final MarkNotificationRead _markNotificationRead;
  final DeleteNotification _deleteNotification;
  final ClearAllNotifications _clearAllNotifications;

  StreamSubscription? _sub;

  void start() {
    if (_sub != null) return;
    emit(const NotificationsLoading());
    _sub = _watchNotifications().listen(
      (items) => emit(NotificationsReady(items)),
      onError: (error, _) => emit(
        NotificationsFailure(
          error is Exception
              ? error.toString().replaceFirst('Exception: ', '')
              : error.toString(),
        ),
      ),
    );
  }

  Future<void> markAsRead(String id) {
    return _markNotificationRead(id);
  }

  Future<void> deleteById(String id) {
    return _deleteNotification(id);
  }

  Future<void> clearAll() {
    return _clearAllNotifications();
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
