import '../repositories/notifications_repository.dart';

class DeleteNotification {
  const DeleteNotification(this._repository);

  final NotificationsRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteNotification(id);
  }
}
