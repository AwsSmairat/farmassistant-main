import '../entities/sensors_snapshot.dart';

/// Live sensor data. Implement with Firestore/IoT in data layer.
abstract class SensorsRepository {
  Stream<SensorsSnapshot> watchSensors();
}
