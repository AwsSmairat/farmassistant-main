import 'dart:html' as html;

import '../../domain/robot_camera_urls.dart';

/// يفتح بث الكاميرا الاحتياطي في تبويب جديد بالمتصفح.
void openRobotCameraInBrowser() {
  html.window.open(RobotCameraUrls.fallback, '_blank');
}
