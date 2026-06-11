// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_camera_browser_open_web.dart
// الطبقة: presentation / widgets (Flutter Web فقط)

// ماذا يفعل؟
//   يفتح رابط بث الكاميرا الاحتياطي في تبويب جديد
//   عند الضغط على «فتح الكاميرا في المتصفح».

// ماذا بداخله؟
//   • openRobotCameraInBrowser() — window.open للرابط الاحتياطي
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'dart:html' as html;

import '../../domain/robot_camera_urls.dart';

/// يفتح بث الكاميرا الاحتياطي في تبويب جديد بالمتصفح.
void openRobotCameraInBrowser() {
  html.window.open(RobotCameraUrls.fallback, '_blank');
}
