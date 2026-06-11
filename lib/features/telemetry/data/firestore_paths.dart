// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: firestore_paths.dart
// المسار: features/telemetry/data/firestore_paths.dart
// الطبقة: features/telemetry/data/firestore_paths.dart
//
// ماذا يفعل؟
//   جزء من ميزة: بيانات المزرعة (Firestore). قراءة/كتابة بيانات المزرعة في Firestore.
//
// ماذا بداخله؟
//   • firestore_paths
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// مسارات Firestore لبيانات الروبوت والمستشعرات (روبوت افتراضي واحد للنسخة الأولى).
abstract final class FarmFirestorePaths {
  /// معرّف الروبوت الافتراضي في المزرعة.
  static const String defaultRobotId = 'robot_001';

  /// صور نباتات مرفوعة يدوياً من مساعد الذكاء الاصطناعي (مسار قديم).
  static const String manualUploadRobotId = 'manual_upload';

  /// تشخيص سحابي من الهاتف فقط — غير مرتبط بـ robot_001.
  static const String externalPhoneUploadRobotId = 'external_phone_upload';

  /// دالة الروبوت doc.
  static String robotDoc(String robotId) => 'robots/$robotId';
  /// دالة أوامر doc.
  static String commandsDoc(String robotId) => 'commands/$robotId';
  /// دالة الروبوت أوامر doc.
  static String robotCommandsDoc(String robotId) => 'robot_commands/$robotId';
  /// دالة الروبوت الحالة doc.
  static String robotStatusDoc(String robotId) => 'robot_status/$robotId';

  /// حقل: robots collection.
  static const String robotsCollection = 'robots';
  /// حقل: المستشعر readings collection.
  static const String sensorReadingsCollection = 'sensor_readings';
  /// حقل: الذكاء الاصطناعي التشخيص collection.
  static const String aiDiagnosisCollection = 'ai_diagnosis';

  /// قناة أوامر قديمة (يُفضّل [robotCommandsCollection]).
  static const String commandsCollection = 'commands';

  /// أوامر التحكم الفورية من تطبيق Flutter إلى الروبوت.
  static const String robotCommandsCollection = 'robot_commands';

  /// حالة الروبوت المباشرة لشاشة التحكم (بطارية، GPS، كاميرا…).
  static const String robotStatusCollection = 'robot_status';
}
