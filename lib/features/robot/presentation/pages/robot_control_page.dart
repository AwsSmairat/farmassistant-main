import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../auth/presentation/widgets/logout_icon_button.dart';
import '../cubit/robot_control_cubit.dart';
import '../cubit/robot_control_state.dart';
import '../widgets/robot_live_camera_card.dart';

/// شاشة التحكم بالروبوت: كاميرا، GPS، مضخة، وضع تلقائي، ولوحة اتجاهات.
class RobotControlPage extends StatelessWidget {
  const RobotControlPage({super.key, this.showBackButton = true});

  /// عند false (داخل HomeShell) يُخفى زر الرجوع.
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RobotControlCubit, RobotControlState>(
      // عرض رسائل الخطأ في SnackBar.
      listenWhen: (p, c) =>
          c.errorMessage != null && c.errorMessage != p.errorMessage,
      listener: (context, state) {
        final msg = state.errorMessage;
        if (msg == null) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.surface,
          ),
        );
      },
      child: BlocBuilder<RobotControlCubit, RobotControlState>(
        builder: (context, state) {
          final cubit = context.read<RobotControlCubit>();
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: LiquidGlassAppBar(
              title: const Text('التحكم بالروبوت'),
              automaticallyImplyLeading: showBackButton,
              leading: showBackButton
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // بث الكاميرا المباشر من الراسبيري باي.
                        RobotLiveCameraCard(
                          streamUrl: state.cameraStreamUrl,
                          isConnected:
                              state.isFirestoreConnected && state.robotOnline,
                        ),
                        const SizedBox(height: 12),
                        _GpsBar(
                          gpsLabel: state.gpsLabel,
                          firestoreConnected: state.isFirestoreConnected,
                          robotOnline: state.robotOnline,
                          onRefresh: cubit.requestGpsRefresh,
                        ),
                        const SizedBox(height: 16),
                        _PrimaryControlRow(
                          autoModeOn: state.autoModeOn,
                          onAutoModeTap: state.isLoading
                              ? null
                              : cubit.toggleAutoMode,
                          onStop: state.isLoading ? null : cubit.sendStop,
                        ),
                        const SizedBox(height: 12),
                        _WaterPumpRow(
                          isOn: state.waterPumpOn,
                          onChanged: state.isLoading ? null : cubit.setPump,
                          onTap: state.isLoading ? null : cubit.togglePump,
                        ),
                        const SizedBox(height: 16),
                        _DirectionPad(
                          enabled: !state.isLoading,
                          onMove: cubit.sendMove,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  // شريط تقدم أثناء إرسال أمر إلى Firestore.
                  if (state.isLoading)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        color: AppColors.primary,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// شريط GPS مع مؤشر الاتصال — الضغط يطلب تحديث الإحداثيات.
class _GpsBar extends StatelessWidget {
  const _GpsBar({
    required this.gpsLabel,
    required this.firestoreConnected,
    required this.robotOnline,
    required this.onRefresh,
  });

  final String gpsLabel;
  final bool firestoreConnected;
  final bool robotOnline;
  final VoidCallback onRefresh;

  String get _subtitle {
    if (!firestoreConnected) return 'جاري الاتصال بـ Firestore…';
    if (!robotOnline) return 'الروبوت غير متصل';
    return gpsLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onRefresh,
          borderRadius: BorderRadius.circular(LiquidGlassTokens.radiusSm),
          child: LiquidGlassPanel(
            borderRadius: LiquidGlassTokens.radiusSm,
            blurSigma: LiquidGlassTokens.blurMedium,
            accentBorder: firestoreConnected && robotOnline
                ? AppColors.info
                : AppColors.warning,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.gps_fixed,
                    color: firestoreConnected && robotOnline
                        ? AppColors.info
                        : AppColors.warning,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'GPS',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ConnectionDot(
                            firestoreConnected: firestoreConnected,
                            robotOnline: robotOnline,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle,
                        style: const TextStyle(
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
        ),
      ),
    );
  }
}

/// نقطة ملوّنة: أصفر=Firestore، أحمر=روبوت غير متصل، أخضر=متصل.
class _ConnectionDot extends StatelessWidget {
  const _ConnectionDot({
    required this.firestoreConnected,
    required this.robotOnline,
  });

  final bool firestoreConnected;
  final bool robotOnline;

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (!firestoreConnected) {
      color = AppColors.warning;
    } else if (!robotOnline) {
      color = AppColors.error;
    } else {
      color = AppColors.success;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// صف الأزرار الرئيسية: الوضع التلقائي وإيقاف الطوارئ.
class _PrimaryControlRow extends StatelessWidget {
  const _PrimaryControlRow({
    required this.autoModeOn,
    required this.onAutoModeTap,
    required this.onStop,
  });

  final bool autoModeOn;
  final VoidCallback? onAutoModeTap;
  final VoidCallback? onStop;

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
              onPressed: onStop,
            ),
          ),
        ],
      ),
    );
  }
}

/// زر إجراء ملوّن (Auto Mode / Stop).
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
  final VoidCallback? onPressed;

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

/// بطاقة مضخة المياه مع مفتاح تشغيل/إيقاف.
class _WaterPumpRow extends StatelessWidget {
  const _WaterPumpRow({
    required this.isOn,
    required this.onChanged,
    required this.onTap,
  });

  final bool isOn;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

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

/// لوحة دائرية للتحكم بالاتجاهات (أمام، خلف، يسار، يمين).
class _DirectionPad extends StatelessWidget {
  const _DirectionPad({
    required this.enabled,
    required this.onMove,
  });

  final bool enabled;
  final Future<void> Function(String direction) onMove;

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
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.7),
                      ),
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
                    child: const Icon(
                      Icons.smart_toy,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_up_rounded,
                      semanticLabel: 'أمام',
                      enabled: enabled,
                      onPressed: () => onMove('forward'),
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      semanticLabel: 'خلف',
                      enabled: enabled,
                      onPressed: () => onMove('backward'),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_left_rounded,
                      semanticLabel: 'يسار',
                      enabled: enabled,
                      onPressed: () => onMove('left'),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_right_rounded,
                      semanticLabel: 'يمين',
                      enabled: enabled,
                      onPressed: () => onMove('right'),
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
}

/// زر سهم واحد في لوحة الاتجاهات.
class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
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
            child: Icon(
              icon,
              color: enabled ? AppColors.primary : AppColors.textMuted,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }
}
