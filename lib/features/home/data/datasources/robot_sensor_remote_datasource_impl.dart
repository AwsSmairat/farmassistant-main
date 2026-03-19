import '../../domain/entities/robot_status.dart';
import 'robot_sensor_remote_datasource.dart';

/// MVP: returns mock robot status and sensor readings.
class RobotSensorRemoteDatasourceImpl implements RobotSensorRemoteDatasource {
  @override
  Future<RobotStatus> getRobotStatus() async => RobotStatus.offline;

  @override
  Future<double?> getLastMoisture() async => 42.5;

  @override
  Future<double?> getLastPh() async => 6.8;

  @override
  Future<double?> getLastEc() async => 1.2;
}
