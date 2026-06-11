// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: dashboard_repository_impl.dart
// المسار: features/home/data/repositories/dashboard_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • DashboardRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/repositories/user_profile_repository.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// تنفيذ مستودع لوحة التحكم.
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(
    this._authRepository,
    this._userProfileRepository,
    this._telemetry,
  );

  /// حقل: المصادقة مستودع.
  final AuthRepository _authRepository;
  /// حقل: المستخدم الملف الشخصي مستودع.
  final UserProfileRepository _userProfileRepository;
  /// حقل: البيانات.
  final FarmFirestoreTelemetryDatasource _telemetry;

  /// دالة داخلية: resolve username.
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
  /// يراقب بثاً مباشراً لـ لوحة التحكم بيانات.
  Stream<DashboardData> watchDashboardData() async* {
    final username = await _resolveUsername();
    yield* _telemetry.watchDashboard(username: username);
  }
}
