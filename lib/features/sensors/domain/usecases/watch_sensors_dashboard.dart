import '../entities/sensors_snapshot.dart';
import '../repositories/sensors_repository.dart';

/// Surfaces live sensor snapshots for the dashboard.
class WatchSensorsDashboard {
  WatchSensorsDashboard(this._repository);

  final SensorsRepository _repository;

  Stream<SensorsSnapshot> call() => _repository.watchSensors();
}
