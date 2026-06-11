import 'package:flutter/material.dart';

/// Android/iOS: عرض البث عبر Image.network (قد يكون محدوداً مع MJPEG).
class RobotLiveCameraStream extends StatelessWidget {
  const RobotLiveCameraStream({
    super.key,
    required this.streamUrl,
    required this.reloadToken,
    this.onReady,
    this.onError,
  });

  final String streamUrl;
  final int reloadToken;
  final VoidCallback? onReady;
  final VoidCallback? onError;

  @override
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
