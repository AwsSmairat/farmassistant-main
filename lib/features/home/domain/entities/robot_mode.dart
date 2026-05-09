/// Robot operating mode for dashboard and control.
enum RobotMode {
  idle,
  moving,
  scanning,
  spraying;

  String get displayName {
    switch (this) {
      case RobotMode.idle:
        return 'خامل';
      case RobotMode.moving:
        return 'يتحرك';
      case RobotMode.scanning:
        return 'يفحص';
      case RobotMode.spraying:
        return 'يرش';
    }
  }
}

