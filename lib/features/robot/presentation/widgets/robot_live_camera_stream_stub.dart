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
