import 'package:equatable/equatable.dart';

enum NotificationSeverity { critical, warning, info }

enum NotificationCategory { sensorAlert, robotStatus, system, activityLog }

class FarmNotification extends Equatable {
  const FarmNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.timestamp,
    required this.isRead,
  });

  final String id;
  final String title;
  final String description;
  final NotificationSeverity severity;
  final NotificationCategory category;
  final DateTime timestamp;
  final bool isRead;

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
