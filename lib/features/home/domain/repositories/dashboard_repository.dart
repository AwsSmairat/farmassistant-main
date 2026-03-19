import '../entities/dashboard_data.dart';

/// Contract for dashboard data. Implementation in data layer.
abstract class DashboardRepository {
  /// Fetches dashboard data for the current user (username from profile, robot/readings from backend or mock).
  Future<DashboardData> getDashboardData();
}
