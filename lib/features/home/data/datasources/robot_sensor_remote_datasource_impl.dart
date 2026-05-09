import '../../domain/entities/robot_status.dart';
import '../../domain/entities/robot_mode.dart';
import '../../domain/entities/dashboard_data.dart';
import 'robot_sensor_remote_datasource.dart';

/// MVP: returns mock robot status and sensor readings.
class RobotSensorRemoteDatasourceImpl implements RobotSensorRemoteDatasource {
  @override
  Future<RobotStatus> getRobotStatus() async => RobotStatus.offline;

  @override
  Future<RobotMode> getRobotMode() async => RobotMode.idle;

  @override
  Future<double?> getBatteryPercent() async => 79;

  @override
  Future<bool?> getPumpOn() async => false;

  @override
  Future<bool?> getGpsOnline() async => true;

  @override
  Future<double?> getWaterTankLevelPercent() async => 66;

  @override
  Future<double?> getSoilMoisturePercent() async => 42.5;

  @override
  Future<double?> getPh() async => 6.8;

  @override
  Future<double?> getEc() async => 1.2;

  @override
  Future<double?> getWaterLevelPercent() async => 61;

  @override
  Future<double?> getTemperatureCelsius() async => 27.7;

  @override
  Future<double?> getHumidityPercent() async => 50.4;

  @override
  Future<AiDiagnosis?> getLatestAiDiagnosis() async {
    return AiDiagnosis(
      resultName: 'سليم',
      confidence: 0.93,
      suggestedTreatment: 'لا يوجد علاج مطلوب. استمر بالمراقبة الدورية.',
      lastScanAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
      isHealthy: true,
    );
  }

  @override
  Future<List<DashboardAlert>> getRecentAlerts() async {
    final now = DateTime.now();
    return [
      DashboardAlert(
        title: 'انخفاض مستوى الماء',
        message: 'مستوى الخزان أقل من 25% — يرجى التعبئة قريباً.',
        priority: AlertPriority.high,
        time: now.subtract(const Duration(minutes: 18)),
      ),
      DashboardAlert(
        title: 'تم تفعيل المضخة',
        message: 'تم تشغيل المضخة تلقائياً لمدة قصيرة.',
        priority: AlertPriority.medium,
        time: now.subtract(const Duration(hours: 1, minutes: 2)),
      ),
      DashboardAlert(
        title: 'فحص ناجح',
        message: 'تمت آخر عملية فحص بدون اكتشاف أمراض.',
        priority: AlertPriority.low,
        time: now.subtract(const Duration(hours: 2, minutes: 12)),
      ),
    ];
  }

  @override
  Future<DailyStats?> getDailyStats() async {
    return DailyStats(
      plantsScannedToday: 24,
      diseasesDetected: 2,
      healthyPlants: 22,
      lastScanTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
    );
  }
}
