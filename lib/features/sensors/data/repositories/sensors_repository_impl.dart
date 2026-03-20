import '../../domain/entities/sensors_snapshot.dart';
import '../../domain/repositories/sensors_repository.dart';
import '../datasources/sensors_remote_datasource.dart';

class SensorsRepositoryImpl implements SensorsRepository {
  SensorsRepositoryImpl(this._datasource);

  final SensorsRemoteDatasource _datasource;

  @override
  Stream<SensorsSnapshot> watchSensors() => _datasource.watchSensors();
}
