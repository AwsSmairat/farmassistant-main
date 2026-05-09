import '../entities/dashboard_data.dart';

/// Contract for dashboard data. Implementation in data layer.
abstract class DashboardRepository {
  /// Live dashboard data (robot + sensors + AI summary).
  Stream<DashboardData> watchDashboardData();
}
