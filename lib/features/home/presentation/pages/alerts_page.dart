// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: alerts_page.dart
// المسار: features/home/presentation/pages/alerts_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • AlertsPage
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
/// شاشة تنبيهات.
class AlertsPage extends StatelessWidget {
  /// دالة تنبيهات صفحة.
  const AlertsPage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        title: const Text('التنبيهات'),
      ),
      body: const Center(
        child: Text(
          'التنبيهات',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
