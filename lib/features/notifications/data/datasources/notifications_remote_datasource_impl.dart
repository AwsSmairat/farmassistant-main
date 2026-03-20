import 'dart:async';

import '../../domain/entities/farm_notification.dart';
import 'notifications_remote_datasource.dart';

class NotificationsRemoteDatasourceImpl implements NotificationsRemoteDatasource {
  NotificationsRemoteDatasourceImpl();

  final StreamController<List<FarmNotification>> _controller =
      StreamController<List<FarmNotification>>.broadcast();

  final List<FarmNotification> _items = [];
  Timer? _timer;
  int _tick = 0;

  @override
  Stream<List<FarmNotification>> watchNotifications() {
    if (_items.isEmpty) {
      _items.addAll(_seed());
    }
    _emit();
    _startFeed();
    return _controller.stream;
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final current = _items[index];
    _items[index] = current.copyWith(isRead: true);
    _emit();
  }

  @override
  Future<void> deleteNotification(String id) async {
    _items.removeWhere((e) => e.id == id);
    _emit();
  }

  @override
  Future<void> clearAll() async {
    _items.clear();
    _emit();
  }

  void _startFeed() {
    _timer ??= Timer.periodic(
      const Duration(seconds: 9),
      (_) {
        _tick++;
        _items.insert(0, _createRealtimeNotification(_tick));
        _emit();
      },
    );
  }

  void _emit() {
    _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _controller.add(List<FarmNotification>.unmodifiable(_items));
  }

  List<FarmNotification> _seed() {
    final now = DateTime.now();
    return [
      FarmNotification(
        id: 'seed-1',
        title: 'Water tank level is low',
        description: 'مستوى خزان الماء منخفض ويحتاج تعبئة.',
        severity: NotificationSeverity.warning,
        category: NotificationCategory.sensorAlert,
        timestamp: now.subtract(const Duration(minutes: 2)),
        isRead: false,
      ),
      FarmNotification(
        id: 'seed-2',
        title: 'Soil moisture is below 20%',
        description: 'رطوبة التربة منخفضة جدا، يفضّل بدء الري.',
        severity: NotificationSeverity.critical,
        category: NotificationCategory.sensorAlert,
        timestamp: now.subtract(const Duration(minutes: 7)),
        isRead: false,
      ),
      FarmNotification(
        id: 'seed-3',
        title: 'Irrigation completed successfully',
        description: 'انتهت مهمة الري بنجاح.',
        severity: NotificationSeverity.info,
        category: NotificationCategory.activityLog,
        timestamp: now.subtract(const Duration(minutes: 13)),
        isRead: true,
      ),
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

  FarmNotification _createRealtimeNotification(int tick) {
    final now = DateTime.now();
    const pool = <_NotifSeed>[
      _NotifSeed(
        title: 'Temperature is too high',
        description: 'درجة الحرارة مرتفعة وتتطلب المراقبة.',
        severity: NotificationSeverity.warning,
        category: NotificationCategory.sensorAlert,
      ),
      _NotifSeed(
        title: 'Robot battery is low',
        description: 'بطارية الروبوت منخفضة، الرجاء الشحن قريبا.',
        severity: NotificationSeverity.critical,
        category: NotificationCategory.system,
      ),
      _NotifSeed(
        title: 'Connection restored',
        description: 'تمت استعادة الاتصال بالنظام.',
        severity: NotificationSeverity.info,
        category: NotificationCategory.system,
      ),
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

class _NotifSeed {
  const _NotifSeed({
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
  });

  final String title;
  final String description;
  final NotificationSeverity severity;
  final NotificationCategory category;
}
