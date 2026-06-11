// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: watch_dashboard_data.dart
// المسار: features/home/domain/usecases/watch_dashboard_data.dart
// الطبقة: domain / usecases — حالة استخدام
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. عملية منطقية واحدة (Use Case).
//
// ماذا بداخله؟
//   • WatchDashboardData
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

/// كلاس مراقبة لوحة التحكم بيانات.
class WatchDashboardData {
  WatchDashboardData(this._repository);

  /// حقل: مستودع.
  final DashboardRepository _repository;

  /// دالة call.
  Stream<DashboardData> call() => _repository.watchDashboardData();
}
