import '../../domain/entities/farm_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remoteDatasource);

  final NotificationsRemoteDatasource _remoteDatasource;

  @override
  Stream<List<FarmNotification>> watchNotifications() {
    return _remoteDatasource.watchNotifications();
  }

  @override
  Future<void> markAsRead(String id) {
    return _remoteDatasource.markAsRead(id);
  }

  @override
  Future<void> deleteNotification(String id) {
    return _remoteDatasource.deleteNotification(id);
  }

  @override
  Future<void> clearAll() {
    return _remoteDatasource.clearAll();
  }
}
