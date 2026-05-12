import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../home/domain/entities/dashboard_data.dart';
import '../../../home/domain/entities/robot_mode.dart';
import '../../../home/domain/entities/robot_status.dart';
import '../../../sensors/domain/entities/sensors_snapshot.dart';
import '../firestore_paths.dart';
import '../models/farm_firestore_models.dart';

/// Central Firestore realtime telemetry + robot commands.
///
/// Queries avoid composite indexes where possible (client-side robotId filter).
class FarmFirestoreTelemetryDatasource {
  FarmFirestoreTelemetryDatasource({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  String get _robotId => FarmFirestorePaths.defaultRobotId;

  /// Dashboard + history include the default robot, legacy null [robotId], and phone uploads.
  bool _includeAiDiagnosisRow(String? robotId) {
    if (robotId == null) return true;
    if (robotId == _robotId) return true;
    if (robotId == FarmFirestorePaths.manualUploadRobotId) return true;
    if (robotId == FarmFirestorePaths.externalPhoneUploadRobotId) return true;
    return false;
  }

  DocumentReference<Map<String, dynamic>> get _robotRef =>
      _db.collection(FarmFirestorePaths.robotsCollection).doc(_robotId);

  DocumentReference<Map<String, dynamic>> get _commandsRef =>
      _db.collection(FarmFirestorePaths.commandsCollection).doc(_robotId);

  /// Combined dashboard: robot doc + latest sensor row + recent AI rows (filtered).
  Stream<DashboardData> watchDashboard({required String username}) {
    DocumentSnapshot<Map<String, dynamic>>? robotSnap;
    QuerySnapshot<Map<String, dynamic>>? sensorSnap;
    QuerySnapshot<Map<String, dynamic>>? aiSnap;

    late final StreamController<DashboardData> controller;
    final subscriptions = <StreamSubscription<dynamic>>[];

    void emit() {
      if (controller.isClosed) return;
      try {
        controller.add(
          _buildDashboard(
            username: username,
            robotSnap: robotSnap,
            sensorSnap: sensorSnap,
            aiSnap: aiSnap,
          ),
        );
      } catch (e, st) {
        controller.addError(e, st);
      }
    }

    controller = StreamController<DashboardData>(
      onListen: () {
        subscriptions.add(
          _robotRef.snapshots().listen((s) {
            robotSnap = s;
            emit();
          }, onError: controller.addError),
        );
        subscriptions.add(
          _db
              .collection(FarmFirestorePaths.sensorReadingsCollection)
              .orderBy('createdAt', descending: true)
              .limit(40)
              .snapshots()
              .listen((s) {
                sensorSnap = s;
                emit();
              }, onError: controller.addError),
        );
        subscriptions.add(
          _db
              .collection(FarmFirestorePaths.aiDiagnosisCollection)
              .orderBy('createdAt', descending: true)
              .limit(80)
              .snapshots()
              .listen((s) {
                aiSnap = s;
                emit();
              }, onError: controller.addError),
        );
      },
      onCancel: () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
        subscriptions.clear();
      },
    );

    return controller.stream;
  }

  Stream<SensorsSnapshot> watchSensorsSnapshot() {
    DocumentSnapshot<Map<String, dynamic>>? robotSnap;
    QuerySnapshot<Map<String, dynamic>>? sensorSnap;

    late final StreamController<SensorsSnapshot> controller;
    final subscriptions = <StreamSubscription<dynamic>>[];

    void emit() {
      if (controller.isClosed) return;
      try {
        controller.add(
          _buildSensorsSnapshot(robotSnap: robotSnap, sensorSnap: sensorSnap),
        );
      } catch (e, st) {
        controller.addError(e, st);
      }
    }

    controller = StreamController<SensorsSnapshot>(
      onListen: () {
        subscriptions.add(
          _robotRef.snapshots().listen((s) {
            robotSnap = s;
            emit();
          }, onError: controller.addError),
        );
        subscriptions.add(
          _db
              .collection(FarmFirestorePaths.sensorReadingsCollection)
              .orderBy('createdAt', descending: true)
              .limit(40)
              .snapshots()
              .listen((s) {
                sensorSnap = s;
                emit();
              }, onError: controller.addError),
        );
      },
      onCancel: () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
        subscriptions.clear();
      },
    );

    return controller.stream;
  }

  /// Raw diagnosis rows for `robot_001` (newest first, capped).
  Stream<List<AiDiagnosisFirestoreDoc>> watchAiDiagnosisDocs({int limit = 50}) {
    return _db
        .collection(FarmFirestorePaths.aiDiagnosisCollection)
        .orderBy('createdAt', descending: true)
        .limit(120)
        .snapshots()
        .map((snap) {
          final list = <AiDiagnosisFirestoreDoc>[];
          for (final doc in snap.docs) {
            final row = AiDiagnosisFirestoreDoc.fromDoc(doc);
            if (row == null) continue;
            if (!_includeAiDiagnosisRow(row.robotId)) continue;
            list.add(row);
            if (list.length >= limit) break;
          }
          return list;
        });
  }

  Future<void> writeMove(String direction) async {
    await _commandsRef.set({
      'move': direction,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> writePump(bool on) async {
    await _commandsRef.set({
      'pump': on,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> writeServo(String direction) async {
    await _commandsRef.set({
      'servo': direction,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> writeScanRequest() async {
    await _commandsRef.set({
      'scan': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  DashboardData _buildDashboard({
    required String username,
    required DocumentSnapshot<Map<String, dynamic>>? robotSnap,
    required QuerySnapshot<Map<String, dynamic>>? sensorSnap,
    required QuerySnapshot<Map<String, dynamic>>? aiSnap,
  }) {
    final robot = robotSnap != null
        ? RobotFirestoreDoc.fromSnapshot(robotSnap)
        : const RobotFirestoreDoc(
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

    SensorReadingFirestoreDoc? sensorRow;
    if (sensorSnap != null) {
      for (final doc in sensorSnap.docs) {
        final parsed = SensorReadingFirestoreDoc.fromDoc(doc);
        if (parsed.robotId == null || parsed.robotId == _robotId) {
          sensorRow = parsed;
          break;
        }
      }
    }

    final aiRows = <AiDiagnosisFirestoreDoc>[];
    if (aiSnap != null) {
      for (final doc in aiSnap.docs) {
        final row = AiDiagnosisFirestoreDoc.fromDoc(doc);
        if (row == null) continue;
        if (!_includeAiDiagnosisRow(row.robotId)) continue;
        aiRows.add(row);
      }
    }

    AiDiagnosis? latestAi;
    if (aiRows.isNotEmpty) {
      aiRows.sort((a, b) {
        final ta = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final tb = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return tb.compareTo(ta);
      });
      final top = aiRows.first;
      final result = top.result?.trim().isNotEmpty == true
          ? top.result!.trim()
          : '—';
      final confRaw = top.confidence;
      final confidence01 = confRaw == null
          ? 0.0
          : confRaw > 1
          ? (confRaw / 100).clamp(0.0, 1.0)
          : confRaw.clamp(0.0, 1.0);
      final treatment = top.treatment?.trim().isNotEmpty == true
          ? top.treatment!.trim()
          : '—';
      latestAi = AiDiagnosis(
        resultName: result,
        confidence: confidence01,
        suggestedTreatment: treatment,
        lastScanAt: top.createdAt ?? DateTime.now(),
        isHealthy: _inferHealthy(result),
      );
    }

    final daily = _deriveDailyStats(aiRows);
    final alerts = _deriveAlerts(robot: robot, sensor: sensorRow);

    return DashboardData(
      username: username,
      robotStatus: _parseRobotStatus(robot.statusRaw),
      robotMode: _parseRobotMode(robot.modeRaw),
      batteryPercent: robot.battery,
      pumpOn: _parsePump(robot.pumpStatus),
      gpsOnline: robot.gpsLat != null && robot.gpsLng != null,
      waterTankLevelPercent: robot.waterLevel ?? sensorRow?.waterLevel,
      soilMoisturePercent: sensorRow?.soilMoisture,
      ph: sensorRow?.ph,
      ec: sensorRow?.ec,
      waterLevelPercent: sensorRow?.waterLevel ?? robot.waterLevel,
      temperatureCelsius: sensorRow?.temperature,
      humidityPercent: sensorRow?.humidity,
      latestAiDiagnosis: latestAi,
      alerts: alerts,
      dailyStats: daily,
    );
  }

  DailyStats? _deriveDailyStats(List<AiDiagnosisFirestoreDoc> rows) {
    if (rows.isEmpty) return null;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    var scanned = 0;
    var diseases = 0;
    var healthy = 0;
    DateTime? lastScan;
    for (final r in rows) {
      final t = r.createdAt;
      if (t == null || t.isBefore(start)) continue;
      scanned++;
      final name = r.result ?? '';
      if (_inferHealthy(name)) {
        healthy++;
      } else {
        diseases++;
      }
      if (lastScan == null || t.isAfter(lastScan)) lastScan = t;
    }
    if (scanned == 0) {
      return DailyStats(
        plantsScannedToday: 0,
        diseasesDetected: 0,
        healthyPlants: 0,
        lastScanTime: rows.first.createdAt,
      );
    }
    return DailyStats(
      plantsScannedToday: scanned,
      diseasesDetected: diseases,
      healthyPlants: healthy,
      lastScanTime: lastScan,
    );
  }

  List<DashboardAlert> _deriveAlerts({
    required RobotFirestoreDoc robot,
    required SensorReadingFirestoreDoc? sensor,
  }) {
    final alerts = <DashboardAlert>[];
    final now = DateTime.now();
    if (robot.exists && robot.battery != null && robot.battery! < 18) {
      alerts.add(
        DashboardAlert(
          title: 'بطارية منخفضة',
          message:
              'قراءة البطارية ${robot.battery!.toStringAsFixed(0)}٪ — يُنصح بالشحن.',
          priority: AlertPriority.high,
          time: robot.lastUpdate ?? now,
        ),
      );
    }
    final water = robot.waterLevel ?? sensor?.waterLevel;
    if (water != null && water < 22) {
      alerts.add(
        DashboardAlert(
          title: 'انخفاض مستوى الماء',
          message:
              'المستوى حوالي ${water.toStringAsFixed(0)}٪ — راجع التزويد بالماء.',
          priority: AlertPriority.medium,
          time: robot.lastUpdate ?? sensor?.createdAt ?? now,
        ),
      );
    }
    if (!robot.exists) {
      alerts.add(
        DashboardAlert(
          title: 'لا توجد بيانات روبوت',
          message: 'أنشئ مستند robots/$_robotId في Firestore للبدء.',
          priority: AlertPriority.low,
          time: now,
        ),
      );
    }
    return alerts;
  }

  SensorsSnapshot _buildSensorsSnapshot({
    required DocumentSnapshot<Map<String, dynamic>>? robotSnap,
    required QuerySnapshot<Map<String, dynamic>>? sensorSnap,
  }) {
    final robot = robotSnap != null
        ? RobotFirestoreDoc.fromSnapshot(robotSnap)
        : const RobotFirestoreDoc(
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

    SensorReadingFirestoreDoc? sensorRow;
    if (sensorSnap != null) {
      for (final doc in sensorSnap.docs) {
        final parsed = SensorReadingFirestoreDoc.fromDoc(doc);
        if (parsed.robotId == null || parsed.robotId == _robotId) {
          sensorRow = parsed;
          break;
        }
      }
    }

    final online = _parseRobotStatus(robot.statusRaw) == RobotStatus.online;
    final lat = robot.gpsLat ?? 0.0;
    final lng = robot.gpsLng ?? 0.0;
    final soil = sensorRow?.soilMoisture ?? 0.0;
    final temp = sensorRow?.temperature ?? 0.0;
    final hum = sensorRow?.humidity ?? 0.0;
    final water = sensorRow?.waterLevel ?? robot.waterLevel ?? 0.0;
    final ph = sensorRow?.ph ?? 7.0;
    final battery = robot.battery ?? 0.0;
    final updated = sensorRow?.createdAt ?? robot.lastUpdate ?? DateTime.now();

    return SensorsSnapshot(
      robotOnline: online,
      latitude: lat,
      longitude: lng,
      soilMoisturePercent: soil,
      temperatureCelsius: temp,
      humidityPercent: hum,
      waterLevelPercent: water,
      ph: ph,
      batteryPercent: battery,
      updatedAt: updated,
    );
  }

  static RobotStatus _parseRobotStatus(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'online':
      case 'متصل':
        return RobotStatus.online;
      case 'offline':
      case 'غير متصل':
        return RobotStatus.offline;
      default:
        return RobotStatus.unknown;
    }
  }

  static RobotMode _parseRobotMode(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'moving':
      case 'move':
        return RobotMode.moving;
      case 'scanning':
      case 'scan':
        return RobotMode.scanning;
      case 'spraying':
      case 'spray':
        return RobotMode.spraying;
      case 'idle':
      default:
        return RobotMode.idle;
    }
  }

  static bool? _parsePump(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = '$v'.toLowerCase();
    if (s == 'on' || s == 'true') return true;
    if (s == 'off' || s == 'false') return false;
    return null;
  }

  static bool _inferHealthy(String resultLoweredOrAny) {
    final s = resultLoweredOrAny.toLowerCase();
    return s.contains('healthy') ||
        s.contains('سليم') ||
        s.contains('normal') ||
        s == 'ok';
  }
}
