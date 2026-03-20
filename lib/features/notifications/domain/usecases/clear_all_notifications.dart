import '../repositories/notifications_repository.dart';

class ClearAllNotifications {
  const ClearAllNotifications(this._repository);

  final NotificationsRepository _repository;

  Future<void> call() {
    return _repository.clearAll();
  }
}
