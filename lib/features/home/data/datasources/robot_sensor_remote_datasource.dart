import '../../domain/entities/robot_status.dart';
import '../../domain/entities/robot_mode.dart';
import '../../domain/entities/dashboard_data.dart';

/// Provides robot status and last sensor readings.
/// MVP: mock data. Replace with real API/Firestore when ready.
abstract class RobotSensorRemoteDatasource {
  Future<RobotStatus> getRobotStatus();
  Future<RobotMode> getRobotMode();
  Future<double?> getBatteryPercent();
  Future<bool?> getPumpOn();
  Future<bool?> getGpsOnline();
  Future<double?> getWaterTankLevelPercent();

  Future<double?> getSoilMoisturePercent();
  Future<double?> getPh();
  Future<double?> getEc();
  Future<double?> getWaterLevelPercent();
  Future<double?> getTemperatureCelsius();
  Future<double?> getHumidityPercent();

  Future<AiDiagnosis?> getLatestAiDiagnosis();
  Future<List<DashboardAlert>> getRecentAlerts();
  Future<DailyStats?> getDailyStats();
}
