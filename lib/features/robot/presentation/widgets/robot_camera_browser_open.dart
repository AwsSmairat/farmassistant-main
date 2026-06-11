// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_camera_browser_open.dart
// الطبقة: presentation / widgets

// ماذا يفعل؟
//   نقطة دخول لفتح بث الكاميرا في تبويب المتصفح
//   (تصدير شرطي حسب المنصة).

// ماذا بداخله؟
//   • على الويب → robot_camera_browser_open_web.dart
//   • غير الويب → robot_camera_browser_open_stub.dart (لا يفعل شيئاً)
//   • الدالة: openRobotCameraInBrowser()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
export 'robot_camera_browser_open_stub.dart'
    if (dart.library.html) 'robot_camera_browser_open_web.dart';
