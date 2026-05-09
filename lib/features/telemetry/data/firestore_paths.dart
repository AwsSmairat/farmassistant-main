/// Firestore paths for robot telemetry (single default robot id for MVP).
abstract final class FarmFirestorePaths {
  static const String defaultRobotId = 'robot_001';

  static String robotDoc(String robotId) => 'robots/$robotId';
  static String commandsDoc(String robotId) => 'commands/$robotId';

  static const String robotsCollection = 'robots';
  static const String sensorReadingsCollection = 'sensor_readings';
  static const String aiDiagnosisCollection = 'ai_diagnosis';
  static const String commandsCollection = 'commands';
}
