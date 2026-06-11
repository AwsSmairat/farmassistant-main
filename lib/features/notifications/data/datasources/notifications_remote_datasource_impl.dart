// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: notifications_remote_datasource_impl.dart
// المسار: features/notifications/data/datasources/notifications_remote_datasource_impl.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. الاتصال بـ Firebase أو API.
//
// ماذا بداخله؟
//   • NotificationsRemoteDatasourceImpl
//   • _NotifSeed
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:async';

import '../../domain/entities/farm_notification.dart';
import 'notifications_remote_datasource.dart';

/// مصدر بيانات التنبيهات بعيد مصدر بيانات تنفيذ.
class NotificationsRemoteDatasourceImpl implements NotificationsRemoteDatasource {
  NotificationsRemoteDatasourceImpl();

  /// حقل: controller.
  final StreamController<List<FarmNotification>> _controller =
      StreamController<List<FarmNotification>>.broadcast();

  /// حقل: items.
  final List<FarmNotification> _items = [];
  Timer? _timer;
  int _tick = 0;

  @override
  /// يراقب بثاً مباشراً لـ التنبيهات.
  Stream<List<FarmNotification>> watchNotifications() {
    if (_items.isEmpty) {
      _items.addAll(_seed());
    }
  /// دالة داخلية: emit.
    _emit();
  /// دالة داخلية: start feed.
    _startFeed();
    return _controller.stream;
  }

  @override
  /// يعلّم as مقروء.
  Future<void> markAsRead(String id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final current = _items[index];
    _items[index] = current.copyWith(isRead: true);
  /// دالة داخلية: emit.
    _emit();
  }

  @override
  /// يحذف التنبيه.
  Future<void> deleteNotification(String id) async {
    _items.removeWhere((e) => e.id == id);
  /// دالة داخلية: emit.
    _emit();
  }

  @override
  /// يمسح all.
  Future<void> clearAll() async {
    _items.clear();
  /// دالة داخلية: emit.
    _emit();
  }

  /// دالة داخلية: start feed.
  void _startFeed() {
    _timer ??= Timer.periodic(
      /// دالة duration.
      const Duration(seconds: 9),
      (_) {
        _tick++;
        _items.insert(0, _createRealtimeNotification(_tick));
      /// دالة داخلية: emit.
        _emit();
      },
    );
  }

  /// دالة داخلية: emit.
  void _emit() {
    _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _controller.add(List<FarmNotification>.unmodifiable(_items));
  }

  /// دالة داخلية: seed.
  List<FarmNotification> _seed() {
    final now = DateTime.now();
    return [
    /// دالة المزرعة التنبيه.
      FarmNotification(
        id: 'seed-1',
        title: 'Water tank level is low',
        description: 'مستوى خزان الماء منخفض ويحتاج تعبئة.',
        severity: NotificationSeverity.warning,
        category: NotificationCategory.sensorAlert,
        timestamp: now.subtract(const Duration(minutes: 2)),
        isRead: false,
      ),
    /// دالة المزرعة التنبيه.
      FarmNotification(
        id: 'seed-2',
        title: 'Soil moisture is below 20%',
        description: 'رطوبة التربة منخفضة جدا، يفضّل بدء الري.',
        severity: NotificationSeverity.critical,
        category: NotificationCategory.sensorAlert,
        timestamp: now.subtract(const Duration(minutes: 7)),
        isRead: false,
      ),
    /// دالة المزرعة التنبيه.
      FarmNotification(
        id: 'seed-3',
        title: 'Irrigation completed successfully',
        description: 'انتهت مهمة الري بنجاح.',
        severity: NotificationSeverity.info,
        category: NotificationCategory.activityLog,
        timestamp: now.subtract(const Duration(minutes: 13)),
        isRead: true,
      ),
    /// دالة المزرعة التنبيه.
      FarmNotification(
        id: 'seed-4',
        title: 'Robot started working',
        description: 'بدأ الروبوت تنفيذ المهمة.',
        severity: NotificationSeverity.info,
        category: NotificationCategory.robotStatus,
        timestamp: now.subtract(const Duration(minutes: 20)),
        isRead: true,
      ),
    ];
  }

  /// دالة داخلية: إنشاء realtime التنبيه.
  FarmNotification _createRealtimeNotification(int tick) {
    final now = DateTime.now();
    const pool = <_NotifSeed>[
    /// دالة داخلية: notif seed.
      _NotifSeed(
        title: 'Temperature is too high',
        description: 'درجة الحرارة مرتفعة وتتطلب المراقبة.',
        severity: NotificationSeverity.warning,
        category: NotificationCategory.sensorAlert,
      ),
    /// دالة داخلية: notif seed.
      _NotifSeed(
        title: 'Robot battery is low',
        description: 'بطارية الروبوت منخفضة، الرجاء الشحن قريبا.',
        severity: NotificationSeverity.critical,
        category: NotificationCategory.system,
      ),
    /// دالة داخلية: notif seed.
      _NotifSeed(
        title: 'Connection restored',
        description: 'تمت استعادة الاتصال بالنظام.',
        severity: NotificationSeverity.info,
        category: NotificationCategory.system,
      ),
    /// دالة داخلية: notif seed.
      _NotifSeed(
        title: 'Movement started',
        description: 'بدأ الروبوت التحرك إلى المسار المحدد.',
        severity: NotificationSeverity.info,
        category: NotificationCategory.activityLog,
      ),
    ];
    final seed = pool[tick % pool.length];
    return FarmNotification(
      id: 'live-$tick-${now.millisecondsSinceEpoch}',
      title: seed.title,
      description: seed.description,
      severity: seed.severity,
      category: seed.category,
      timestamp: now,
      isRead: false,
    );
  }
}

/// كلاس notif seed.
class _NotifSeed {
  /// دالة داخلية: notif seed.
  const _NotifSeed({
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
  });

  /// حقل: title.
  final String title;
  /// حقل: description.
  final String description;
  /// حقل: severity.
  final NotificationSeverity severity;
  /// حقل: category.
  final NotificationCategory category;
}
