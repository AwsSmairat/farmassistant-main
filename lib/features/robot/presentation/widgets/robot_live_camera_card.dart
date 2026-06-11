// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_live_camera_card.dart
// الطبقة: presentation / widgets

// ماذا يفعل؟
//   بطاقة واجهة «Live Camera» — تعرض بث MJPEG
//   مع إعادة محاولة على الجوال وزر فتح في المتصفح على الويب.

// ماذا بداخله؟
//   • RobotLiveCameraCard — البطاقة الرئيسية (StatefulWidget)
//   • _reloadStream() — إعادة تحميل البث
//   • _StreamLoadingView — مؤشر تحميل (جوال)
//   • _StreamErrorView — شاشة خطأ + إعادة اتصال (جوال)
//   • على الويب: iframe مباشر + زر «فتح الكاميرا في المتصفح»
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import 'robot_camera_browser_open.dart';
import 'robot_live_camera_stream.dart';

/// بطاقة الكاميرا المباشرة — iframe على الويب، Image.network على الجوال.
class RobotLiveCameraCard extends StatefulWidget {
  /// دالة الروبوت مباشر الكاميرا بطاقة.
  const RobotLiveCameraCard({
    super.key,
    required this.streamUrl,
    required this.isConnected,
  });

  /// رابط بث MJPEG.
  final String streamUrl;

  /// هل الروبوت وFirestore متصلان؟
  final bool isConnected;

  @override
  /// ينشئ الحالة.
  State<RobotLiveCameraCard> createState() => _RobotLiveCameraCardState();
}

/// حالة واجهة الروبوت مباشر الكاميرا بطاقة.
class _RobotLiveCameraCardState extends State<RobotLiveCameraCard> {
  /// فترة إعادة المحاولة التلقائية على الجوال.
  static const _retryInterval = Duration(seconds: 4);

  /// يزيد عند إعادة تحميل البث لإنشاء عنصر عرض جديد.
  int _reloadToken = 0;
  bool _streamError = false;
  bool _firstFrame = false;
  Timer? _retryTimer;
  bool _wasConnected = false;

  @override
  /// يهيّئ الويدجت.
  void initState() {
    super.initState();
    _wasConnected = widget.isConnected;
  }

  @override
  /// يستجيب لتغيّر خصائص الويدجت.
  void didUpdateWidget(covariant RobotLiveCameraCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إعادة التحميل عند تغيّر الرابط.
    if (oldWidget.streamUrl != widget.streamUrl) {
    /// دالة داخلية: reload البث.
      _reloadStream();
    }
    // إعادة التحميل عند عودة اتصال الروبوت.
    if (!_wasConnected && widget.isConnected) {
    /// دالة داخلية: reload البث.
      _reloadStream();
    }
    _wasConnected = widget.isConnected;
  }

  @override
  /// ينظف الموارد.
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  /// إعادة تهيئة البث (iframe جديد أو Image.network جديد).
  void _reloadStream() {
    _retryTimer?.cancel();
  /// يعيّن الحالة.
    setState(() {
      _streamError = false;
      // على الويب لا ننتظر onLoad — نعرض iframe مباشرة.
      _firstFrame = kIsWeb ? true : false;
      _reloadToken++;
    });
  }

  /// معالجة فشل البث (جوال فقط).
  void _onStreamError() {
    if (kIsWeb || _streamError) return;
  /// يعيّن الحالة.
    setState(() => _streamError = true);
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(_retryInterval, (_) {
      if (!mounted || !_streamError) return;
    /// دالة داخلية: reload البث.
      _reloadStream();
    });
  }

  /// إخفاء مؤشر التحميل عند وصول أول إطار (جوال فقط).
  void _onStreamReady() {
    if (kIsWeb || (_firstFrame && !_streamError)) return;
    _retryTimer?.cancel();
    if (mounted) {
      setState(() {
        _streamError = false;
        _firstFrame = true;
      });
    }
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width;
    final horizontalPad = maxWidth >= 600 ? 24.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 0),
      child: LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurMedium,
        accentBorder: AppColors.primary.withValues(alpha: 0.35),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // عنوان البطاقة وزر إعادة المحاولة (جوال).
          /// دالة صف.
            Row(
              children: [
                /// دالة أيقونة.
                const Icon(Icons.videocam, color: AppColors.primary, size: 20),
                /// دالة sized box.
                const SizedBox(width: 8),
                /// دالة expanded.
                const Expanded(
                  child: Text(
                    'Live Camera',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!kIsWeb && _streamError)
                /// دالة نص زر.
                  TextButton(
                    onPressed: _reloadStream,
                    child: const Text('إعادة المحاولة'),
                  ),
              ],
            ),
            /// دالة sized box.
            const SizedBox(height: 10),
            // منطقة العرض بنسبة 4:3.
          /// دالة clip rrect.
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ColoredBox(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.45),
                  child: kIsWeb
                      /// دالة الروبوت مباشر الكاميرا البث.
                      ? RobotLiveCameraStream(
                          key: ValueKey(
                            '${widget.streamUrl}#$_reloadToken',
                          ),
                          streamUrl: widget.streamUrl,
                          reloadToken: _reloadToken,
                        )
                      : _streamError
                          /// دالة داخلية: البث خطأ عرض.
                          ? _StreamErrorView(onRetry: _reloadStream)
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                              /// دالة الروبوت مباشر الكاميرا البث.
                                RobotLiveCameraStream(
                                  streamUrl: widget.streamUrl,
                                  reloadToken: _reloadToken,
                                  onReady: _onStreamReady,
                                  onError: _onStreamError,
                                ),
                                if (!_firstFrame) const _StreamLoadingView(),
                              ],
                            ),
                ),
              ),
            ),
            // زر فتح البث في المتصفح (ويب فقط).
            if (kIsWeb) ...[
              /// دالة sized box.
              const SizedBox(height: 8),
            /// دالة align.
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: openRobotCameraInBrowser,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('فتح الكاميرا في المتصفح'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// مؤشر تحميل أثناء انتظار أول إطار (جوال).
class _StreamLoadingView extends StatelessWidget {
  /// دالة داخلية: البث تحميل عرض.
  const _StreamLoadingView();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          /// دالة sized box.
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          /// دالة sized box.
            SizedBox(height: 12),
          /// دالة نص.
            Text(
              'جاري الاتصال بالكاميرا…',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شاشة خطأ مع زر إعادة الاتصال (جوال).
class _StreamErrorView extends StatelessWidget {
  /// دالة داخلية: البث خطأ عرض.
  const _StreamErrorView({required this.onRetry});

  /// حقل: on retry.
  final VoidCallback onRetry;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// دالة أيقونة.
              const Icon(
                Icons.videocam_off_outlined,
                color: AppColors.error,
                size: 40,
              ),
              /// دالة sized box.
              const SizedBox(height: 10),
              /// دالة نص.
              const Text(
                'تعذر عرض بث الكاميرا',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              /// دالة sized box.
              const SizedBox(height: 6),
              /// دالة نص.
              const Text(
                'تحقق من تشغيل الروبوت والشبكة المحلية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              /// دالة sized box.
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('إعادة الاتصال'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
