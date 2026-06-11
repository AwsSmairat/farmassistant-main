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
