// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: notifications_repository.dart
// المسار: features/notifications/domain/repositories/notifications_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • NotificationsRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/farm_notification.dart';

/// واجهة مستودع التنبيهات.
abstract class NotificationsRepository {
  /// يراقب بثاً مباشراً لـ التنبيهات.
  Stream<List<FarmNotification>> watchNotifications();

  /// يعلّم as مقروء.
  Future<void> markAsRead(String id);

  /// يحذف التنبيه.
  Future<void> deleteNotification(String id);

  /// يمسح all.
  Future<void> clearAll();
}
