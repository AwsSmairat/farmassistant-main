/// مسارات Firestore لبيانات الروبوت والمستشعرات (روبوت افتراضي واحد للنسخة الأولى).
abstract final class FarmFirestorePaths {
  /// معرّف الروبوت الافتراضي في المزرعة.
  static const String defaultRobotId = 'robot_001';

  /// صور نباتات مرفوعة يدوياً من مساعد الذكاء الاصطناعي (مسار قديم).
  static const String manualUploadRobotId = 'manual_upload';

  /// تشخيص سحابي من الهاتف فقط — غير مرتبط بـ robot_001.
  static const String externalPhoneUploadRobotId = 'external_phone_upload';

  static String robotDoc(String robotId) => 'robots/$robotId';
  static String commandsDoc(String robotId) => 'commands/$robotId';
  static String robotCommandsDoc(String robotId) => 'robot_commands/$robotId';
  static String robotStatusDoc(String robotId) => 'robot_status/$robotId';

  static const String robotsCollection = 'robots';
  static const String sensorReadingsCollection = 'sensor_readings';
  static const String aiDiagnosisCollection = 'ai_diagnosis';

  /// قناة أوامر قديمة (يُفضّل [robotCommandsCollection]).
  static const String commandsCollection = 'commands';

  /// أوامر التحكم الفورية من تطبيق Flutter إلى الروبوت.
  static const String robotCommandsCollection = 'robot_commands';

  /// حالة الروبوت المباشرة لشاشة التحكم (بطارية، GPS، كاميرا…).
  static const String robotStatusCollection = 'robot_status';
}
