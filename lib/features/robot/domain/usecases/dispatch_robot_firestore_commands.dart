import '../../../telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';

/// Writes control intents to Firestore `commands/{robotId}` (merge writes).
class DispatchRobotFirestoreCommands {
  DispatchRobotFirestoreCommands(this._telemetry);

  final FarmFirestoreTelemetryDatasource _telemetry;

  Future<void> sendMove(String direction) => _telemetry.writeMove(direction);

  Future<void> sendPump(bool on) => _telemetry.writePump(on);

  Future<void> sendServo(String direction) => _telemetry.writeServo(direction);

  Future<void> requestScan() => _telemetry.writeScanRequest();
}
