import '../entities/farm_notification.dart';
import '../repositories/notifications_repository.dart';

class WatchNotifications {
  const WatchNotifications(this._repository);

  final NotificationsRepository _repository;

  Stream<List<FarmNotification>> call() {
    return _repository.watchNotifications();
  }
}
