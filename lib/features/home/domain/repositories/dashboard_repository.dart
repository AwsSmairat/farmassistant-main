// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: dashboard_repository.dart
// المسار: features/home/domain/repositories/dashboard_repository.dart
// الطبقة: domain / repositories — واجهة المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • DashboardRepository
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/dashboard_data.dart';
/// واجهة مستودع لوحة التحكم.
abstract class DashboardRepository {
  /// Live dashboard data (robot + sensors + AI summary).
  /// يراقب بثاً مباشراً لـ لوحة التحكم بيانات.
  Stream<DashboardData> watchDashboardData();
}
