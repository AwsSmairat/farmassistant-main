// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: clear_all_notifications.dart
// المسار: features/notifications/domain/usecases/clear_all_notifications.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • ClearAllNotifications
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../repositories/notifications_repository.dart';

/// كلاس مسح all التنبيهات.
class ClearAllNotifications {
  /// دالة مسح all التنبيهات.
  const ClearAllNotifications(this._repository);

  /// حقل: مستودع.
  final NotificationsRepository _repository;

  /// دالة call.
  Future<void> call() {
    return _repository.clearAll();
  }
}
