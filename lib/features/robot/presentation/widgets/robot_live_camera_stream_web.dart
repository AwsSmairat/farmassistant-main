// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_live_camera_stream_web.dart
// الطبقة: presentation / widgets (Flutter Web فقط)

// ماذا يفعل؟
//   يعرض بث MJPEG على Flutter Web عبر iframe مدمج
//   باستخدام HtmlElementView و platformViewRegistry.

// ماذا بداخله؟
//   • RobotLiveCameraStream — StatefulWidget للويب
//   • _registerView() — تسجيل iframe في platformViewRegistry
//   • IFrameElement — src = رابط الكاميرا، بدون حدود، 100% عرض/ارتفاع
//   • DivElement — غلاف لملء الحاوية
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// Flutter Web: عرض بث MJPEG عبر iframe بملء الحاوية بدون إطار.
class RobotLiveCameraStream extends StatefulWidget {
  const RobotLiveCameraStream({
    super.key,
    required this.streamUrl,
    required this.reloadToken,
    this.onReady,
    this.onError,
  });

  /// رابط بث الكاميرا من Firestore أو الاحتياطي.
  final String streamUrl;

  /// رقم إعادة التحميل — يُستخدم في ValueKey لإنشاء iframe جديد.
  final int reloadToken;
  final VoidCallback? onReady;
  final VoidCallback? onError;

  @override
  State<RobotLiveCameraStream> createState() => _RobotLiveCameraStreamState();
}

class _RobotLiveCameraStreamState extends State<RobotLiveCameraStream> {
  /// عداد فريد لتسجيل كل iframe في platformViewRegistry.
  static int _nextViewId = 0;

  /// معرّف العرض المسجّل — يُعيَّن مرة واحدة في initState.
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = _registerView(widget.streamUrl);
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onReady?.call());
  }

  /// تسجيل عنصر iframe في سجل عروض Flutter Web.
  String _registerView(String streamUrl) {
    final viewType = 'robot-camera-iframe-${_nextViewId++}';

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        // إنشاء iframe بملء الحاوية بدون حدود.
        final iframe = html.IFrameElement()
          ..src = streamUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'block'
          ..allowFullscreen = true;
        iframe.setAttribute('frameborder', '0');
        iframe.setAttribute('scrolling', 'no');

        // غلاف div لضمان ملء المساحة بالكامل.
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.overflow = 'hidden'
          ..style.margin = '0'
          ..style.padding = '0';
        container.append(iframe);
        return container;
      },
    );

    return viewType;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
