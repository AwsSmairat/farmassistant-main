import '../repositories/notifications_repository.dart';

class MarkNotificationRead {
  const MarkNotificationRead(this._repository);

  final NotificationsRepository _repository;

  Future<void> call(String id) {
    return _repository.markAsRead(id);
  }
}
