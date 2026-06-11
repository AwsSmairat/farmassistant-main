// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_command_service.dart
// الطبقة: data / services

// ماذا يفعل؟
//   جسر الاتصال بين التطبيق و Firestore للروبوت.
//   يكتب أوامر التحكم في robot_commands/robot_001
//   ويستمع لحالة الروبوت من robot_status/robot_001.

// ماذا بداخله؟
//   • RobotCommandService — الخدمة الرئيسية
//   • watchRobotStatus() — بث مباشر لتحديثات الحالة
//   • sendMove / sendPump / sendAutoMode / requestGpsRefresh — إرسال الأوامر
//   • _merge() — دمج الحقول مع updatedAt في Firestore
//   • _parseStatus() — تحويل مستند Firestore إلى RobotLiveStatus
//   • _formatGps() — تنسيق إحداثيات GPS للعرض
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../telemetry/data/firestore_paths.dart';
import '../../domain/entities/robot_live_status.dart';
import '../../domain/robot_camera_urls.dart';

/// جسر Firestore: كتابة الأوامر في robot_commands وقراءة الحالة من robot_status.
class RobotCommandService {
  RobotCommandService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  /// حقل: db.
  final FirebaseFirestore _db;

  /// معرّف الروبوت الافتراضي.
  static const String robotId = FarmFirestorePaths.defaultRobotId;

  /// يحلّ عنوان الكاميرا من Firestore أو يستخدم الاحتياطي.
  static String resolveCameraUrl(String? fromFirestore) =>
      RobotCameraUrls.resolve(fromFirestore);

  /// مرجع مستند الأوامر: robot_commands/robot_001.
  DocumentReference<Map<String, dynamic>> get _commandsRef => _db
      .collection(FarmFirestorePaths.robotCommandsCollection)
      .doc(robotId);

  /// مرجع مستند الحالة: robot_status/robot_001.
  DocumentReference<Map<String, dynamic>> get _statusRef => _db
      .collection(FarmFirestorePaths.robotStatusCollection)
      .doc(robotId);

  /// بث مباشر لتحديثات حالة الروبوت.
  Stream<RobotLiveStatus> watchRobotStatus() {
    return _statusRef.snapshots().map(_parseStatus);
  }

  /// إرسال أمر حركة إلى الروبوت.
  Future<void> sendMove(String move) => _merge({
        'move': move,
      });

  /// إرسال أمر تشغيل/إيقاف المضخة.
  Future<void> sendPump(bool pump) => _merge({
        'pump': pump,
      });

  /// إرسال أمر الوضع التلقائي.
  Future<void> sendAutoMode(bool autoMode) => _merge({
        'autoMode': autoMode,
      });

  /// طلب تحديث GPS من جهاز الروبوت.
  Future<void> requestGpsRefresh() => _merge({
        'gpsRefresh': true,
      });

  /// دمج الحقول في مستند الأوامر مع طابع زمني للخادم.
  Future<void> _merge(Map<String, dynamic> fields) async {
    await _commandsRef.set(
      {
        ...fields,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    /// دالة set إعدادات.
      SetOptions(merge: true),
    );
  }

  /// تحويل مستند Firestore إلى كائن RobotLiveStatus.
  RobotLiveStatus _parseStatus(DocumentSnapshot<Map<String, dynamic>> snap) {
    if (!snap.exists) {
      return const RobotLiveStatus(exists: false);
    }
    final data = snap.data() ?? {};
    return RobotLiveStatus(
      exists: true,
      online: data['online'] == true,
      battery: _asDouble(data['battery']),
      tankLevel: _asDouble(data['tankLevel']),
      moisture: _asDouble(data['moisture']),
      gpsLabel: _formatGps(data['gps']),
      currentMove: data['currentMove']?.toString(),
      pump: data['pump'] is bool ? data['pump'] as bool : null,
      autoMode: data['autoMode'] is bool ? data['autoMode'] as bool : null,
      cameraUrl: data['cameraUrl']?.toString(),
    );
  }

  /// تحويل قيمة رقمية من Firestore إلى double.
  static double? _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// تنسيق حقل GPS (نص أو خريطة lat/lng) لعرضه في الواجهة.
  static String? _formatGps(Object? gps) {
    if (gps == null) return null;
    if (gps is String && gps.trim().isNotEmpty) return gps.trim();
    if (gps is Map) {
      final lat = _asDouble(gps['lat'] ?? gps['latitude']);
      final lng = _asDouble(gps['lng'] ?? gps['longitude'] ?? gps['lon']);
      if (lat != null && lng != null) {
        final latH = lat >= 0 ? 'N' : 'S';
        final lngH = lng >= 0 ? 'E' : 'W';
        return '${lat.abs().toStringAsFixed(2)}° $latH, ${lng.abs().toStringAsFixed(2)}° $lngH';
      }
    }
    return gps.toString();
  }
}
