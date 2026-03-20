import '../../domain/entities/sensors_snapshot.dart';

/// Live sensor feed. Replace body with Firestore snapshots or MQTT bridge.
abstract class SensorsRemoteDatasource {
  Stream<SensorsSnapshot> watchSensors();
}
