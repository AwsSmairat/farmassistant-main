import 'package:equatable/equatable.dart';

import 'robot_status.dart';

/// Dashboard data for the home screen (username, robot status, last sensor readings).
class DashboardData extends Equatable {
  const DashboardData({
    this.username,
    this.robotStatus = RobotStatus.unknown,
    this.lastMoisture,
    this.lastPh,
    this.lastEc,
  });

  final String? username;
  final RobotStatus robotStatus;
  final double? lastMoisture;
  final double? lastPh;
  final double? lastEc;

  @override
  List<Object?> get props => [username, robotStatus, lastMoisture, lastPh, lastEc];
}
