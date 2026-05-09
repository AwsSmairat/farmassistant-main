import '../../../telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';
import '../../domain/entities/sensors_snapshot.dart';
import 'sensors_remote_datasource.dart';

/// Live sensor readings from Firestore (+ robot GPS/battery strip).
class SensorsRemoteDatasourceImpl implements SensorsRemoteDatasource {
  SensorsRemoteDatasourceImpl(this._telemetry);

  final FarmFirestoreTelemetryDatasource _telemetry;

  @override
  Stream<SensorsSnapshot> watchSensors() => _telemetry.watchSensorsSnapshot();
}
