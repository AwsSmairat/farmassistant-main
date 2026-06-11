// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_live_camera_stream_stub.dart
// الطبقة: presentation / widgets (احتياطي)

// ماذا يفعل؟
//   تنفيذ وهمي يُستخدم عندما لا تكون المنصة ويب ولا IO
//   (مثلاً اختبارات أو منصات غير مدعومة).

// ماذا بداخله؟
//   • RobotLiveCameraStream — يعرض رسالة:
//     «بث الكاميرا غير مدعوم على هذه المنصة»
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// احتياطي عندما لا تتوفر منصة ويب ولا IO.
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
    return const ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Text(
          'بث الكاميرا غير مدعوم على هذه المنصة',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
