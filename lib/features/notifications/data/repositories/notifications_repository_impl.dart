// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: notifications_repository_impl.dart
// المسار: features/notifications/data/repositories/notifications_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • NotificationsRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/farm_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

/// تنفيذ مستودع التنبيهات.
class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remoteDatasource);

  /// حقل: بعيد مصدر بيانات.
  final NotificationsRemoteDatasource _remoteDatasource;

  @override
  /// يراقب بثاً مباشراً لـ التنبيهات.
  Stream<List<FarmNotification>> watchNotifications() {
    return _remoteDatasource.watchNotifications();
  }

  @override
  /// يعلّم as مقروء.
  Future<void> markAsRead(String id) {
    return _remoteDatasource.markAsRead(id);
  }

  @override
  /// يحذف التنبيه.
  Future<void> deleteNotification(String id) {
    return _remoteDatasource.deleteNotification(id);
  }

  @override
  /// يمسح all.
  Future<void> clearAll() {
    return _remoteDatasource.clearAll();
  }
}
