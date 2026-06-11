// تصدير شرطي: فتح الكاميرا في تبويب المتصفح (ويب فقط).
export 'robot_camera_browser_open_stub.dart'
    if (dart.library.html) 'robot_camera_browser_open_web.dart';
