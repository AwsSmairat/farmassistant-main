// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_control_page.dart
// الطبقة: presentation / pages

// ماذا يفعل؟
//   الشاشة الكاملة للتحكم بالروبوت — تجمع الكاميرا والأزرار
//   ولوحة الاتجاهات وتعرضها للمستخدم.

// ماذا بداخله؟
//   • RobotControlPage — الصفحة الرئيسية (BlocBuilder + Scaffold)
//   • RobotLiveCameraCard — بث الكاميرا في الأعلى
//   • _GpsBar — شريط GPS مع مؤشر الاتصال
//   • _ConnectionDot — نقطة ملوّنة لحالة الاتصال
//   • _PrimaryControlRow — Auto Mode + Stop
//   • _ActionButton — زر إجراء ملوّن
//   • _WaterPumpRow — بطاقة مضخة المياه + Switch
//   • _DirectionPad — لوحة دائرية للاتجاهات
//   • _ArrowButton — زر سهم واحد
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
  /// دالة الروبوت التحكم صفحة.
  const RobotControlPage({super.key, this.showBackButton = true});

  /// عند false (داخل HomeShell) يُخفى زر الرجوع.
  final bool showBackButton;

  @override
  /// يبني شجرة الواجهة (Widget).
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
        /// دالة snack شريط.
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
          /// دالة scaffold.
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: LiquidGlassAppBar(
              title: const Text('التحكم بالروبوت'),
              automaticallyImplyLeading: showBackButton,
              leading: showBackButton
                  /// دالة أيقونة زر.
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    )
                  : null,
              actions: const [
              /// دالة تسجيل خروج أيقونة زر.
                LogoutIconButton(),
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                /// دالة single child scroll عرض.
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // بث الكاميرا المباشر من الراسبيري باي.
                      /// دالة الروبوت مباشر الكاميرا بطاقة.
                        RobotLiveCameraCard(
                          streamUrl: state.cameraStreamUrl,
                          isConnected:
                              state.isFirestoreConnected && state.robotOnline,
                        ),
                        /// دالة sized box.
                        const SizedBox(height: 12),
                      /// دالة داخلية: GPS شريط.
                        _GpsBar(
                          gpsLabel: state.gpsLabel,
                          firestoreConnected: state.isFirestoreConnected,
                          robotOnline: state.robotOnline,
                          onRefresh: cubit.requestGpsRefresh,
                        ),
                        /// دالة sized box.
                        const SizedBox(height: 16),
                      /// دالة داخلية: رئيسي التحكم صف.
                        _PrimaryControlRow(
                          autoModeOn: state.autoModeOn,
                          onAutoModeTap: state.isLoading
                              ? null
                              : cubit.toggleAutoMode,
                          onStop: state.isLoading ? null : cubit.sendStop,
                        ),
                        /// دالة sized box.
                        const SizedBox(height: 12),
                      /// دالة داخلية: مياه مضخة صف.
                        _WaterPumpRow(
                          isOn: state.waterPumpOn,
                          onChanged: state.isLoading ? null : cubit.setPump,
                          onTap: state.isLoading ? null : cubit.togglePump,
                        ),
                        /// دالة sized box.
                        const SizedBox(height: 16),
                      /// دالة داخلية: direction لوحة.
                        _DirectionPad(
                          enabled: !state.isLoading,
                          onMove: cubit.sendMove,
                        ),
                        /// دالة sized box.
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  // شريط تقدم أثناء إرسال أمر إلى Firestore.
                  if (state.isLoading)
                    /// دالة positioned.
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
  /// دالة داخلية: GPS شريط.
  const _GpsBar({
    required this.gpsLabel,
    required this.firestoreConnected,
    required this.robotOnline,
    required this.onRefresh,
  });

  /// حقل: GPS label.
  final String gpsLabel;
  /// حقل: Firestore connected.
  final bool firestoreConnected;
  /// حقل: الروبوت متصل.
  final bool robotOnline;
  /// حقل: on تحديث.
  final VoidCallback onRefresh;

  String get _subtitle {
    if (!firestoreConnected) return 'جاري الاتصال بـ Firestore…';
    if (!robotOnline) return 'الروبوت غير متصل';
    return gpsLabel;
  }

  @override
  /// يبني شجرة الواجهة (Widget).
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
              /// دالة container.
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
                /// دالة sized box.
                const SizedBox(width: 12),
              /// دالة expanded.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    /// دالة صف.
                      Row(
                        children: [
                          /// دالة نص.
                          const Text(
                            'GPS',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          /// دالة sized box.
                          const SizedBox(width: 8),
                        /// دالة داخلية: اتصال نقطة.
                          _ConnectionDot(
                            firestoreConnected: firestoreConnected,
                            robotOnline: robotOnline,
                          ),
                        ],
                      ),
                      /// دالة sized box.
                      const SizedBox(height: 2),
                    /// دالة نص.
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
  /// دالة داخلية: اتصال نقطة.
  const _ConnectionDot({
    required this.firestoreConnected,
    required this.robotOnline,
  });

  /// حقل: Firestore connected.
  final bool firestoreConnected;
  /// حقل: الروبوت متصل.
  final bool robotOnline;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    /// حقل: color.
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
  /// دالة داخلية: رئيسي التحكم صف.
  const _PrimaryControlRow({
    required this.autoModeOn,
    required this.onAutoModeTap,
    required this.onStop,
  });

  /// حقل: تلقائي وضع on.
  final bool autoModeOn;
  /// حقل: on تلقائي وضع tap.
  final VoidCallback? onAutoModeTap;
  /// حقل: on stop.
  final VoidCallback? onStop;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
        /// دالة expanded.
          Expanded(
            child: _ActionButton(
              label: autoModeOn ? 'Auto On' : 'Auto Mode',
              icon: Icons.auto_mode,
              color: autoModeOn ? AppColors.success : AppColors.warning,
              onPressed: onAutoModeTap,
            ),
          ),
          /// دالة sized box.
          const SizedBox(width: 12),
        /// دالة expanded.
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
  /// دالة داخلية: إجراء زر.
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  /// حقل: label.
  final String label;
  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: color.
  final Color color;
  /// حقل: on pressed.
  final VoidCallback? onPressed;

  @override
  /// يبني شجرة الواجهة (Widget).
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
            /// دالة أيقونة.
              Icon(icon, color: color, size: 22),
              /// دالة sized box.
              const SizedBox(width: 8),
            /// دالة نص.
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
  /// دالة داخلية: مياه مضخة صف.
  const _WaterPumpRow({
    required this.isOn,
    required this.onChanged,
    required this.onTap,
  });

  /// حقل: is on.
  final bool isOn;
  /// حقل: on changed.
  final ValueChanged<bool>? onChanged;
  /// حقل: on tap.
  final VoidCallback? onTap;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    /// حقل: بطاقة color.
    final Color cardColor = isOn
        ? AppColors.accentBlue.withValues(alpha: 0.18)
        : AppColors.error.withValues(alpha: 0.16);
    /// حقل: border color.
    final Color borderColor = isOn
        ? AppColors.accentBlue.withValues(alpha: 0.55)
        : AppColors.error.withValues(alpha: 0.5);
    /// حقل: أيقونة bg.
    final Color iconBg = isOn
        ? AppColors.accentBlue.withValues(alpha: 0.35)
        : AppColors.error.withValues(alpha: 0.28);
    /// حقل: accent.
    final Color accent = isOn ? AppColors.accentBlue : AppColors.error;
    /// حقل: الحالة color.
    final Color statusColor = accent;
    /// حقل: splash.
    final Color splash = accent.withValues(alpha: 0.14);
    /// حقل: highlight.
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
              /// دالة container.
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
                /// دالة sized box.
                const SizedBox(width: 12),
              /// دالة expanded.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    /// دالة نص.
                      Text(
                        'مضخة المياه',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    /// دالة نص.
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
              /// دالة switch.
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
  /// دالة داخلية: direction لوحة.
  const _DirectionPad({
    required this.enabled,
    required this.onMove,
  });

  /// حقل: enabled.
  final bool enabled;
  /// دالة function.
  final Future<void> Function(String direction) onMove;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          /// دالة نص.
          const Text(
            'لوحة التحكم بالحركة',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          /// دالة sized box.
          const SizedBox(height: 10),
        /// دالة center.
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                /// دالة container.
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border, width: 1.4),
                      boxShadow: [
                      /// دالة box shadow.
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                /// دالة container.
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
                /// دالة container.
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
                /// دالة positioned.
                  Positioned(
                    top: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_up_rounded,
                      semanticLabel: 'أمام',
                      enabled: enabled,
                      onPressed: () => onMove('forward'),
                    ),
                  ),
                /// دالة positioned.
                  Positioned(
                    bottom: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      semanticLabel: 'خلف',
                      enabled: enabled,
                      onPressed: () => onMove('backward'),
                    ),
                  ),
                /// دالة positioned.
                  Positioned(
                    left: 18,
                    child: _ArrowButton(
                      icon: Icons.keyboard_arrow_left_rounded,
                      semanticLabel: 'يسار',
                      enabled: enabled,
                      onPressed: () => onMove('left'),
                    ),
                  ),
                /// دالة positioned.
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
  /// دالة داخلية: سهم زر.
  const _ArrowButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.enabled = true,
  });

  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: semantic label.
  final String semanticLabel;
  /// حقل: on pressed.
  final VoidCallback? onPressed;
  /// حقل: enabled.
  final bool enabled;

  @override
  /// يبني شجرة الواجهة (Widget).
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
              /// دالة box shadow.
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
