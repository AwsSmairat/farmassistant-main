// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: watch_notifications.dart
// المسار: features/notifications/domain/usecases/watch_notifications.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • WatchNotifications
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/farm_notification.dart';
import '../repositories/notifications_repository.dart';

/// كلاس مراقبة التنبيهات.
class WatchNotifications {
  /// دالة مراقبة التنبيهات.
  const WatchNotifications(this._repository);

  /// حقل: مستودع.
  final NotificationsRepository _repository;

  /// دالة call.
  Stream<List<FarmNotification>> call() {
    return _repository.watchNotifications();
  }
}
