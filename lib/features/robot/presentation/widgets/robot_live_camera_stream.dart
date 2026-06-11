// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_live_camera_stream.dart
// الطبقة: presentation / widgets

// ماذا يفعل؟
//   نقطة دخول واحدة لعرض البث — يختار التنفيذ حسب المنصة
//   (تصدير شرطي conditional export).

// ماذا بداخله؟
//   • على الويب → robot_live_camera_stream_web.dart (iframe)
//   • على Android/iOS → robot_live_camera_stream_io.dart (Image.network)
//   • غير ذلك → robot_live_camera_stream_stub.dart (رسالة غير مدعوم)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
export 'robot_live_camera_stream_stub.dart'
    if (dart.library.html) 'robot_live_camera_stream_web.dart'
    if (dart.library.io) 'robot_live_camera_stream_io.dart';
