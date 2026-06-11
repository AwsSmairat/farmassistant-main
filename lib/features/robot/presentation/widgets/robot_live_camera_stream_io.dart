// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_live_camera_stream_io.dart
// الطبقة: presentation / widgets (Android / iOS)

// ماذا يفعل؟
//   يعرض بث الكاميرا على الجوال عبر Image.network.
//   (MJPEG قد لا يعمل بسلاسة على كل الأجهزة).

// ماذا بداخله؟
//   • RobotLiveCameraStream — StatelessWidget
//   • Image.network — تحميل البث مع fit: cover
//   • frameBuilder — إشعار الواجهة عند أول إطار (onReady)
//   • errorBuilder — إشعار الواجهة عند الفشل (onError)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:flutter/material.dart';

/// Android/iOS: عرض البث عبر Image.network (قد يكون محدوداً مع MJPEG).
class RobotLiveCameraStream extends StatelessWidget {
  /// دالة الروبوت مباشر الكاميرا البث.
  const RobotLiveCameraStream({
    super.key,
    required this.streamUrl,
    required this.reloadToken,
    this.onReady,
    this.onError,
  });

  /// حقل: البث url.
  final String streamUrl;
  /// حقل: reload token.
  final int reloadToken;
  /// حقل: on ready.
  final VoidCallback? onReady;
  /// حقل: on خطأ.
  final VoidCallback? onError;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Image.network(
      streamUrl,
      key: ValueKey('$streamUrl#$reloadToken'),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      width: double.infinity,
      height: double.infinity,
      // إشعار الواجهة عند وصول أول إطار.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          onReady?.call();
          return child;
        }
        return child;
      },
      // إشعار الواجهة عند فشل التحميل.
      errorBuilder: (context, error, stackTrace) {
        onError?.call();
        return const SizedBox.shrink();
      },
    );
  }
}
