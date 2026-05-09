import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/robot_sensor_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(
    this._authRepository,
    this._userProfileRepository,
    this._robotSensorDatasource,
  );

  final AuthRepository _authRepository;
  final UserProfileRepository _userProfileRepository;
  final RobotSensorRemoteDatasource _robotSensorDatasource;

  @override
  Future<DashboardData> getDashboardData() async {
    final user = _authRepository.currentUser;
    final uid = user?.id;
    String? username;
    if (uid != null) {
      try {
        username = await _userProfileRepository.getUsernameByUid(uid);
      } on PermissionDeniedException {
        // Firestore rules may block profile reads; fall back to auth data.
        username = null;
      }
    }
    username ??= user?.displayName ?? user?.email ?? 'مستخدم';

    final status = await _robotSensorDatasource.getRobotStatus();
    final mode = await _robotSensorDatasource.getRobotMode();
    final battery = await _robotSensorDatasource.getBatteryPercent();
    final pumpOn = await _robotSensorDatasource.getPumpOn();
    final gpsOnline = await _robotSensorDatasource.getGpsOnline();
    final tank = await _robotSensorDatasource.getWaterTankLevelPercent();

    final soil = await _robotSensorDatasource.getSoilMoisturePercent();
    final ph = await _robotSensorDatasource.getPh();
    final ec = await _robotSensorDatasource.getEc();
    final waterLevel = await _robotSensorDatasource.getWaterLevelPercent();
    final temp = await _robotSensorDatasource.getTemperatureCelsius();
    final humidity = await _robotSensorDatasource.getHumidityPercent();

    final ai = await _robotSensorDatasource.getLatestAiDiagnosis();
    final alerts = await _robotSensorDatasource.getRecentAlerts();
    final stats = await _robotSensorDatasource.getDailyStats();

    return DashboardData(
      username: username,
      robotStatus: status,
      robotMode: mode,
      batteryPercent: battery,
      pumpOn: pumpOn,
      gpsOnline: gpsOnline,
      waterTankLevelPercent: tank,
      soilMoisturePercent: soil,
      ph: ph,
      ec: ec,
      waterLevelPercent: waterLevel,
      temperatureCelsius: temp,
      humidityPercent: humidity,
      latestAiDiagnosis: ai,
      alerts: alerts,
      dailyStats: stats,
    );
  }
}
