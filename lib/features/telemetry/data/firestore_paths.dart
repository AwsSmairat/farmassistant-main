/// Firestore paths for robot telemetry (single default robot id for MVP).
abstract final class FarmFirestorePaths {
  static const String defaultRobotId = 'robot_001';

  /// Hand-uploaded plant images from the in-app AI assistant (legacy mock path).
  static const String manualUploadRobotId = 'manual_upload';

  /// Phone-only cloud diagnosis (Cloud Function + external AI), not tied to robot_001.
  static const String externalPhoneUploadRobotId = 'external_phone_upload';

  static String robotDoc(String robotId) => 'robots/$robotId';
  static String commandsDoc(String robotId) => 'commands/$robotId';

  static const String robotsCollection = 'robots';
  static const String sensorReadingsCollection = 'sensor_readings';
  static const String aiDiagnosisCollection = 'ai_diagnosis';
  static const String commandsCollection = 'commands';
}
