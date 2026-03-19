import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';
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
      username = await _userProfileRepository.getUsernameByUid(uid);
    }
    username ??= user?.displayName ?? user?.email ?? 'مستخدم';

    final status = await _robotSensorDatasource.getRobotStatus();
    final moisture = await _robotSensorDatasource.getLastMoisture();
    final ph = await _robotSensorDatasource.getLastPh();
    final ec = await _robotSensorDatasource.getLastEc();

    return DashboardData(
      username: username,
      robotStatus: status,
      lastMoisture: moisture,
      lastPh: ph,
      lastEc: ec,
    );
  }
}
