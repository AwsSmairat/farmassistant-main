// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: farm_notification.dart
// المسار: features/notifications/domain/entities/farm_notification.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. جزء من ميزة التنبيهات.
//
// ماذا بداخله؟
//   • FarmNotification
//   • enum NotificationSeverity
//   • enum NotificationCategory
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

/// تعداد التنبيه severity.
enum NotificationSeverity { critical, warning, info }

/// تعداد التنبيه category.
enum NotificationCategory { sensorAlert, robotStatus, system, activityLog }

/// كلاس المزرعة التنبيه.
class FarmNotification extends Equatable {
  /// دالة المزرعة التنبيه.
  const FarmNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.timestamp,
    required this.isRead,
  });

  /// حقل: id.
  final String id;
  /// حقل: title.
  final String title;
  /// حقل: description.
  final String description;
  /// حقل: severity.
  final NotificationSeverity severity;
  /// حقل: category.
  final NotificationCategory category;
  /// حقل: timestamp.
  final DateTime timestamp;
  /// حقل: is مقروء.
  final bool isRead;

  /// ينسخ الكائن مع تعديل بعض الحقول.
  FarmNotification copyWith({
    String? id,
    String? title,
    String? description,
    NotificationSeverity? severity,
    NotificationCategory? category,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return FarmNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  /// يُرجع props.
  List<Object?> get props => [
        id,
        title,
        description,
        severity,
        category,
        timestamp,
        isRead,
      ];
}
