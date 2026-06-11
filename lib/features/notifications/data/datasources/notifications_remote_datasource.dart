// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: notifications_remote_datasource.dart
// المسار: features/notifications/data/datasources/notifications_remote_datasource.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. الاتصال بـ Firebase أو API.
//
// ماذا بداخله؟
//   • NotificationsRemoteDatasource
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/farm_notification.dart';

/// مصدر بيانات التنبيهات بعيد مصدر بيانات.
abstract class NotificationsRemoteDatasource {
  /// يراقب بثاً مباشراً لـ التنبيهات.
  Stream<List<FarmNotification>> watchNotifications();

  /// يعلّم as مقروء.
  Future<void> markAsRead(String id);

  /// يحذف التنبيه.
  Future<void> deleteNotification(String id);

  /// يمسح all.
  Future<void> clearAll();
}
