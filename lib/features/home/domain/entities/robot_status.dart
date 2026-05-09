/// Robot connection/status for dashboard.
enum RobotStatus {
  online,
  offline,
  unknown;

  String get displayName {
    switch (this) {
      case RobotStatus.online:
        return 'متصل';
      case RobotStatus.offline:
        return 'غير متصل';
      case RobotStatus.unknown:
        return '—';
    }
  }
}
