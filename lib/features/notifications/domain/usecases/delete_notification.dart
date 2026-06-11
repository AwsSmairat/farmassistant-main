// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: delete_notification.dart
// المسار: features/notifications/domain/usecases/delete_notification.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. جزء من ميزة التنبيهات.
//
// ماذا بداخله؟
//   • DeleteNotification
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../repositories/notifications_repository.dart';

/// كلاس حذف التنبيه.
class DeleteNotification {
  /// دالة حذف التنبيه.
  const DeleteNotification(this._repository);

  /// حقل: مستودع.
  final NotificationsRepository _repository;

  /// دالة call.
  Future<void> call(String id) {
    return _repository.deleteNotification(id);
  }
}
