import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../auth/presentation/widgets/logout_icon_button.dart';

/// Robot control: Start/Stop, Water Pump, Auto Mode, arrows, camera, GPS.
class RobotControlPage extends StatefulWidget {
  const RobotControlPage({super.key, this.showBackButton = true});

  /// When false (e.g. inside HomeShell), leading back button is hidden.
  final bool showBackButton;

  @override
  State<RobotControlPage> createState() => _RobotControlPageState();
}

class _RobotControlPageState extends State<RobotControlPage> {
  bool _waterPumpOn = false;
  bool _autoModeOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        title: const Text('التحكم بالروبوت'),
        automaticallyImplyLeading: widget.showBackButton,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        actions: const [
          LogoutIconButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _GpsBar(),
              const SizedBox(height: 12),
              const _CameraView(),
              const SizedBox(height: 16),
              _PrimaryControlRow(
                autoModeOn: _autoModeOn,
                onAutoModeTap: () => setState(() => _autoModeOn = !_autoModeOn),
                onStop: _showSnack,
              ),
              const SizedBox(height: 12),
              _WaterPumpRow(
                isOn: _waterPumpOn,
                onChanged: (v) => setState(() => _waterPumpOn = v),
                onTap: () => setState(() => _waterPumpOn = !_waterPumpOn),
              ),
              const SizedBox(height: 16),
              const _DirectionPad(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}

class _GpsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurMedium,
        accentBorder: AppColors.info,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.gps_fixed, color: AppColors.info, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GPS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '31.95° N, 35.93° E',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: LiquidGlassPanel(
          borderRadius: LiquidGlassTokens.radiusSm,
          blurSigma: LiquidGlassTokens.blurMedium,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.35),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam, size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 8),
                  Text(
                    'الكاميرا',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryControlRow extends StatelessWidget {
  const _PrimaryControlRow({
    required this.autoModeOn,
    required this.onAutoModeTap,
    required this.onStop,
  });

  final bool autoModeOn;
  final VoidCallback onAutoModeTap;
  final void Function(String) onStop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: autoModeOn ? 'Auto On' : 'Auto Mode',
              icon: Icons.auto_mode,
              color: autoModeOn ? AppColors.success : AppColors.warning,
              onPressed: onAutoModeTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              label: 'Stop',
              icon: Icons.stop,
              color: AppColors.error,
              onPressed: () => onStop('Stop'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaterPumpRow extends StatelessWidget {
  const _WaterPumpRow({
    required this.isOn,
    required this.onChanged,
    required this.onTap,
  });

  final bool isOn;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isOn
        ? AppColors.accentBlue.withValues(alpha: 0.18)
        : AppColors.error.withValues(alpha: 0.16);
    final Color borderColor = isOn
        ? AppColors.accentBlue.withValues(alpha: 0.55)
        : AppColors.error.withValues(alpha: 0.5);
    final Color iconBg = isOn
        ? AppColors.accentBlue.withValues(alpha: 0.35)
        : AppColors.error.withValues(alpha: 0.28);
    final Color accent = isOn ? AppColors.accentBlue : AppColors.error;
    final Color statusColor = accent;
    final Color splash = accent.withValues(alpha: 0.14);
    final Color highlight = accent.withValues(alpha: 0.09);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: splash,
          highlightColor: highlight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.water_drop,
                    color: accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'مضخة المياه',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        isOn ? 'تشغيل' : 'إيقاف',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isOn,
                  onChanged: onChanged,
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.accentBlue;
                    }
                    return AppColors.error;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.accentBlue.withValues(alpha: 0.45);
                    }
                    return AppColors.error.withValues(alpha: 0.35);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DirectionPad extends StatelessWidget {
  const _DirectionPad();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'لوحة التحكم بالحركة',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border, width: 1.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 164,
                    height: 164,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceVariant.withValues(alpha: 0.55),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
                    ),
                  ),
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceVariant,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.smart_toy, color: AppColors.primary, size: 32),
                  ),
                  Positioned(
                    top: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_up_rounded,
                      semanticLabel: 'أمام',
                      onPressed: () => _onDirection(context, 'أمام'),
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      semanticLabel: 'خلف',
                      onPressed: () => _onDirection(context, 'خلف'),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_left_rounded,
                      semanticLabel: 'يسار',
                      onPressed: () => _onDirection(context, 'يسار'),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_right_rounded,
                      semanticLabel: 'يمين',
                      onPressed: () => _onDirection(context, 'يمين'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDirection(BuildContext context, String direction) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(direction),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Ink(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant,
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 36),
          ),
        ),
      ),
    );
  }
}
