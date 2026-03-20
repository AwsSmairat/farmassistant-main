import '../../domain/entities/farm_notification.dart';

abstract class NotificationsRemoteDatasource {
  Stream<List<FarmNotification>> watchNotifications();

  Future<void> markAsRead(String id);

  Future<void> deleteNotification(String id);

  Future<void> clearAll();
}
