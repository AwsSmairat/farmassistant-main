// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: mark_notification_read.dart
// المسار: features/notifications/domain/usecases/mark_notification_read.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • MarkNotificationRead
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../repositories/notifications_repository.dart';

/// كلاس تعليم التنبيه مقروء.
class MarkNotificationRead {
  /// دالة تعليم التنبيه مقروء.
  const MarkNotificationRead(this._repository);

  /// حقل: مستودع.
  final NotificationsRepository _repository;

  /// دالة call.
  Future<void> call(String id) {
    return _repository.markAsRead(id);
  }
}
