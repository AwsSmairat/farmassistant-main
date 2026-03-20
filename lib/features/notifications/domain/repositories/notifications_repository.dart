import '../entities/farm_notification.dart';

abstract class NotificationsRepository {
  Stream<List<FarmNotification>> watchNotifications();

  Future<void> markAsRead(String id);

  Future<void> deleteNotification(String id);

  Future<void> clearAll();
}
