import 'package:cloud_firestore/cloud_firestore.dart';

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse('$v');
}

DateTime? _asDate(dynamic v) {
  if (v is Timestamp) return v.toDate();
  return null;
}

/// Raw robot document under [FarmFirestorePaths.robotsCollection]/robotId.
class RobotFirestoreDoc {
  const RobotFirestoreDoc({
    required this.statusRaw,
    required this.modeRaw,
    required this.battery,
    required this.waterLevel,
    required this.pumpStatus,
    required this.gpsLat,
    required this.gpsLng,
    required this.lastUpdate,
    required this.exists,
  });

  final String? statusRaw;
  final String? modeRaw;
  final double? battery;
  final double? waterLevel;
  final dynamic pumpStatus;
  final double? gpsLat;
  final double? gpsLng;
  final DateTime? lastUpdate;
  final bool exists;

  static RobotFirestoreDoc fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    if (!snap.exists || snap.data() == null) {
      return const RobotFirestoreDoc(
        statusRaw: null,
        modeRaw: null,
        battery: null,
        waterLevel: null,
        pumpStatus: null,
        gpsLat: null,
        gpsLng: null,
        lastUpdate: null,
        exists: false,
      );
    }
    final d = snap.data()!;
    return RobotFirestoreDoc(
      statusRaw: d['status'] as String?,
      modeRaw: d['mode'] as String?,
      battery: _asDouble(d['battery']),
      waterLevel: _asDouble(d['waterLevel']),
      pumpStatus: d['pumpStatus'],
      gpsLat: _asDouble(d['gpsLat']),
      gpsLng: _asDouble(d['gpsLng']),
      lastUpdate: _asDate(d['lastUpdate']),
      exists: true,
    );
  }
}

/// One row in [FarmFirestorePaths.sensorReadingsCollection].
class SensorReadingFirestoreDoc {
  const SensorReadingFirestoreDoc({
    required this.robotId,
    required this.soilMoisture,
    required this.ph,
    required this.ec,
    required this.temperature,
    required this.humidity,
    required this.waterLevel,
    required this.distance,
    required this.createdAt,
    required this.exists,
  });

  final String? robotId;
  final double? soilMoisture;
  final double? ph;
  final double? ec;
  final double? temperature;
  final double? humidity;
  final double? waterLevel;
  final double? distance;
  final DateTime? createdAt;
  final bool exists;

  static SensorReadingFirestoreDoc fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return SensorReadingFirestoreDoc(
      robotId: d['robotId'] as String?,
      soilMoisture: _asDouble(d['soilMoisture']),
      ph: _asDouble(d['ph']),
      ec: _asDouble(d['ec']),
      temperature: _asDouble(d['temperature']),
      humidity: _asDouble(d['humidity']),
      waterLevel: _asDouble(d['waterLevel']),
      distance: _asDouble(d['distance']),
      createdAt: _asDate(d['createdAt']),
      exists: true,
    );
  }
}

/// One row in [FarmFirestorePaths.aiDiagnosisCollection].
class AiDiagnosisFirestoreDoc {
  const AiDiagnosisFirestoreDoc({
    required this.id,
    required this.robotId,
    required this.result,
    required this.confidence,
    required this.treatment,
    required this.imageUrl,
    required this.createdAt,
  });

  final String id;
  final String? robotId;
  final String? result;
  final double? confidence;
  final String? treatment;
  final String? imageUrl;
  final DateTime? createdAt;

  static AiDiagnosisFirestoreDoc? fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    final createdAt = _asDate(d['createdAt']);
    return AiDiagnosisFirestoreDoc(
      id: doc.id,
      robotId: d['robotId'] as String?,
      result: d['result'] as String?,
      confidence: _asDouble(d['confidence']),
      treatment: d['treatment'] as String?,
      imageUrl: d['imageUrl'] as String?,
      createdAt: createdAt,
    );
  }
}
