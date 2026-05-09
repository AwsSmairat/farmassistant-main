import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

class WatchDashboardData {
  WatchDashboardData(this._repository);

  final DashboardRepository _repository;

  Stream<DashboardData> call() => _repository.watchDashboardData();
}
