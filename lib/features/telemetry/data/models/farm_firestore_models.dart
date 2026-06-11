// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: farm_firestore_models.dart
// المسار: features/telemetry/data/models/farm_firestore_models.dart
// الطبقة: data / models — نموذج بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: بيانات المزرعة (Firestore). قراءة/كتابة بيانات المزرعة في Firestore.
//
// ماذا بداخله؟
//   • RobotFirestoreDoc
//   • SensorReadingFirestoreDoc
//   • AiDiagnosisFirestoreDoc
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
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
/// كلاس الروبوت Firestore doc.
class RobotFirestoreDoc {
  /// دالة الروبوت Firestore doc.
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

  /// حقل: الحالة raw.
  final String? statusRaw;
  /// حقل: وضع raw.
  final String? modeRaw;
  /// حقل: بطارية.
  final double? battery;
  /// حقل: مياه مستوى.
  final double? waterLevel;
  /// حقل: مضخة الحالة.
  final dynamic pumpStatus;
  /// حقل: GPS lat.
  final double? gpsLat;
  /// حقل: GPS lng.
  final double? gpsLng;
  /// حقل: last تحديث.
  final DateTime? lastUpdate;
  /// حقل: exists.
  final bool exists;

  /// دالة from لقطة.
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
/// كلاس المستشعر reading Firestore doc.
class SensorReadingFirestoreDoc {
  /// دالة المستشعر reading Firestore doc.
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

  /// حقل: الروبوت id.
  final String? robotId;
  /// حقل: soil رطوبة.
  final double? soilMoisture;
  /// حقل: ph.
  final double? ph;
  /// حقل: ec.
  final double? ec;
  /// حقل: temperature.
  final double? temperature;
  /// حقل: humidity.
  final double? humidity;
  /// حقل: مياه مستوى.
  final double? waterLevel;
  /// حقل: distance.
  final double? distance;
  /// حقل: created at.
  final DateTime? createdAt;
  /// حقل: exists.
  final bool exists;

  /// دالة from doc.
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
/// كلاس الذكاء الاصطناعي التشخيص Firestore doc.
class AiDiagnosisFirestoreDoc {
  /// دالة الذكاء الاصطناعي التشخيص Firestore doc.
  const AiDiagnosisFirestoreDoc({
    required this.id,
    required this.robotId,
    required this.result,
    required this.confidence,
    required this.treatment,
    required this.imageUrl,
    required this.createdAt,
    this.userId,
    this.source,
    this.diseaseName,
    this.explanation,
  });

  /// حقل: id.
  final String id;
  /// حقل: الروبوت id.
  final String? robotId;
  /// حقل: نتيجة.
  final String? result;
  /// حقل: confidence.
  final double? confidence;
  /// حقل: treatment.
  final String? treatment;
  /// حقل: الصورة url.
  final String? imageUrl;
  /// حقل: created at.
  final DateTime? createdAt;
  /// حقل: المستخدم id.
  final String? userId;
  /// حقل: source.
  final String? source;
  /// حقل: disease name.
  final String? diseaseName;
  /// حقل: explanation.
  final String? explanation;

  /// دالة from doc.
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
      userId: d['userId'] as String?,
      source: d['source'] as String?,
      diseaseName: d['diseaseName'] as String?,
      explanation: d['explanation'] as String?,
    );
  }
}
