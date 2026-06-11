/// عناوين بث كاميرا MJPEG للروبوت الافتراضي.
abstract final class RobotCameraUrls {
  /// عنوان البث الاحتياطي عند غياب cameraUrl من Firestore.
  static const String fallback =
      'http://172.16.14.243:5000/video_feed';

  /// يُرجع عنوان الكاميرا من Firestore أو العنوان الاحتياطي.
  static String resolve(String? fromFirestore) {
    final trimmed = fromFirestore?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    return fallback;
  }
}
