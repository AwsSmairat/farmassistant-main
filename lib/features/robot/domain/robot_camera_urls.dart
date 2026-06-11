// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_camera_urls.dart
// الطبقة: domain

// ماذا يفعل؟
//   يحدد عنوان بث كاميرا الراسبيري باي (MJPEG)
//   ويختار بين الرابط من Firestore والرابط الاحتياطي.

// ماذا بداخله؟
//   • RobotCameraUrls — كلاس ثابت للعناوين
//   • fallback — الرابط الافتراضي: 172.16.14.243:5000/video_feed
//   • resolve() — يُرجع cameraUrl من Firestore أو fallback
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
