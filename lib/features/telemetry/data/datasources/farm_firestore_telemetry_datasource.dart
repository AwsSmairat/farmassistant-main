// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: farm_firestore_telemetry_datasource.dart
// المسار: features/telemetry/data/datasources/farm_firestore_telemetry_datasource.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: بيانات المزرعة (Firestore). الاتصال بـ Firebase أو API — قراءة/كتابة بيانات المزرعة في Firestore.
//
// ماذا بداخله؟
//   • FarmFirestoreTelemetryDatasource
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
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
/// مصدر بيانات المزرعة Firestore البيانات مصدر بيانات.
class FarmFirestoreTelemetryDatasource {
  FarmFirestoreTelemetryDatasource({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  /// حقل: db.
  final FirebaseFirestore _db;

  /// يُرجع الروبوت id.
  String get _robotId => FarmFirestorePaths.defaultRobotId;

  /// Dashboard + history include the default robot, legacy null [robotId], and phone uploads.
  /// دالة داخلية: include الذكاء الاصطناعي التشخيص صف.
  bool _includeAiDiagnosisRow(String? robotId) {
    if (robotId == null) return true;
    if (robotId == _robotId) return true;
    if (robotId == FarmFirestorePaths.manualUploadRobotId) return true;
    if (robotId == FarmFirestorePaths.externalPhoneUploadRobotId) return true;
    return false;
  }

  /// يُرجع الروبوت ref.
  DocumentReference<Map<String, dynamic>> get _robotRef =>
      _db.collection(FarmFirestorePaths.robotsCollection).doc(_robotId);

  /// يُرجع أوامر ref.
  DocumentReference<Map<String, dynamic>> get _commandsRef =>
      _db.collection(FarmFirestorePaths.commandsCollection).doc(_robotId);

  /// Combined dashboard: robot doc + latest sensor row + recent AI rows (filtered).
  /// يراقب بثاً مباشراً لـ لوحة التحكم.
  Stream<DashboardData> watchDashboard({required String username}) {
    DocumentSnapshot<Map<String, dynamic>>? robotSnap;
    QuerySnapshot<Map<String, dynamic>>? sensorSnap;
    QuerySnapshot<Map<String, dynamic>>? aiSnap;

    /// حقل: controller.
    late final StreamController<DashboardData> controller;
    final subscriptions = <StreamSubscription<dynamic>>[];

    /// يصدّر حالة جديدة.
    void emit() {
      if (controller.isClosed) return;
      try {
        controller.add(
        /// دالة داخلية: build لوحة التحكم.
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
          /// يصدّر حالة جديدة.
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
              /// يصدّر حالة جديدة.
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
              /// يصدّر حالة جديدة.
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

  /// يراقب بثاً مباشراً لـ المستشعرات لقطة.
  Stream<SensorsSnapshot> watchSensorsSnapshot() {
    DocumentSnapshot<Map<String, dynamic>>? robotSnap;
    QuerySnapshot<Map<String, dynamic>>? sensorSnap;

    /// حقل: controller.
    late final StreamController<SensorsSnapshot> controller;
    final subscriptions = <StreamSubscription<dynamic>>[];

    /// يصدّر حالة جديدة.
    void emit() {
      if (controller.isClosed) return;
      try {
        controller.add(
        /// دالة داخلية: build المستشعرات لقطة.
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
          /// يصدّر حالة جديدة.
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
              /// يصدّر حالة جديدة.
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
  /// يراقب بثاً مباشراً لـ الذكاء الاصطناعي التشخيص docs.
  Stream<List<AiDiagnosisFirestoreDoc>> watchAiDiagnosisDocs({int limit = 50}) {
    return _db
        .collection(FarmFirestorePaths.aiDiagnosisCollection)
        .orderBy('createdAt', descending: true)
        .limit(120)
        .snapshots()
        .map((snap) {
          final list = <AiDiagnosisFirestoreDoc>[];
        /// دالة for.
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

  /// دالة write حركة.
  Future<void> writeMove(String direction) async {
    await _commandsRef.set({
      'move': direction,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// دالة write مضخة.
  Future<void> writePump(bool on) async {
    await _commandsRef.set({
      'pump': on,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// دالة write servo.
  Future<void> writeServo(String direction) async {
    await _commandsRef.set({
      'servo': direction,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// دالة write scan طلب.
  Future<void> writeScanRequest() async {
    await _commandsRef.set({
      'scan': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// دالة داخلية: build لوحة التحكم.
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

  /// دالة داخلية: derive daily stats.
  DailyStats? _deriveDailyStats(List<AiDiagnosisFirestoreDoc> rows) {
    if (rows.isEmpty) return null;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    var scanned = 0;
    var diseases = 0;
    var healthy = 0;
    DateTime? lastScan;
  /// دالة for.
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

  /// دالة داخلية: derive تنبيهات.
  List<DashboardAlert> _deriveAlerts({
    required RobotFirestoreDoc robot,
    required SensorReadingFirestoreDoc? sensor,
  }) {
    final alerts = <DashboardAlert>[];
    final now = DateTime.now();
    if (robot.exists && robot.battery != null && robot.battery! < 18) {
      alerts.add(
      /// دالة لوحة التحكم تنبيه.
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
      /// دالة لوحة التحكم تنبيه.
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
      /// دالة لوحة التحكم تنبيه.
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

  /// دالة داخلية: build المستشعرات لقطة.
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

  /// دالة داخلية: parse الروبوت الحالة.
  static RobotStatus _parseRobotStatus(String? raw) {
  /// دالة switch.
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

  /// دالة داخلية: parse الروبوت وضع.
  static RobotMode _parseRobotMode(String? raw) {
  /// دالة switch.
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

  /// دالة داخلية: parse مضخة.
  static bool? _parsePump(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = '$v'.toLowerCase();
    if (s == 'on' || s == 'true') return true;
    if (s == 'off' || s == 'false') return false;
    return null;
  }

  /// دالة داخلية: infer healthy.
  static bool _inferHealthy(String resultLoweredOrAny) {
    final s = resultLoweredOrAny.toLowerCase();
    return s.contains('healthy') ||
        s.contains('سليم') ||
        s.contains('normal') ||
        s == 'ok';
  }
}
