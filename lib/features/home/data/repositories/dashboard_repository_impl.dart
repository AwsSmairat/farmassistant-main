import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(
    this._authRepository,
    this._userProfileRepository,
    this._telemetry,
  );

  final AuthRepository _authRepository;
  final UserProfileRepository _userProfileRepository;
  final FarmFirestoreTelemetryDatasource _telemetry;

  Future<String> _resolveUsername() async {
    final user = _authRepository.currentUser;
    final uid = user?.id;
    String? username;
    if (uid != null) {
      try {
        username = await _userProfileRepository.getUsernameByUid(uid);
      } on PermissionDeniedException {
        username = null;
      }
    }
    username ??= user?.displayName ?? user?.email ?? 'مستخدم';
    return username;
  }

  @override
  Stream<DashboardData> watchDashboardData() async* {
    final username = await _resolveUsername();
    yield* _telemetry.watchDashboard(username: username);
  }
}
