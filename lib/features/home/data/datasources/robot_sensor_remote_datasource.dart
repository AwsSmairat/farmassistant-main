import '../../domain/entities/robot_status.dart';

/// Provides robot status and last sensor readings.
/// MVP: mock data. Replace with real API/Firestore when ready.
abstract class RobotSensorRemoteDatasource {
  Future<RobotStatus> getRobotStatus();
  Future<double?> getLastMoisture();
  Future<double?> getLastPh();
  Future<double?> getLastEc();
}
