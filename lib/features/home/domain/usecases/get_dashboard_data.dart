import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

/// Loads dashboard data for the home screen.
class GetDashboardData {
  GetDashboardData(this._repository);

  final DashboardRepository _repository;

  Future<DashboardData> call() => _repository.getDashboardData();
}
