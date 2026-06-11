// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_remote_datasource_impl.dart
// المسار: features/sensors/data/datasources/sensors_remote_datasource_impl.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. الاتصال بـ Firebase أو API.
//
// ماذا بداخله؟
//   • SensorsRemoteDatasourceImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../../telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';
import '../../domain/entities/sensors_snapshot.dart';
import 'sensors_remote_datasource.dart';
/// مصدر بيانات المستشعرات بعيد مصدر بيانات تنفيذ.
class SensorsRemoteDatasourceImpl implements SensorsRemoteDatasource {
  SensorsRemoteDatasourceImpl(this._telemetry);

  /// حقل: البيانات.
  final FarmFirestoreTelemetryDatasource _telemetry;

  @override
  /// يراقب بثاً مباشراً لـ المستشعرات.
  Stream<SensorsSnapshot> watchSensors() => _telemetry.watchSensorsSnapshot();
}
