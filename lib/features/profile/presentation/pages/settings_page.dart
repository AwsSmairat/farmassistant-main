// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: settings_page.dart
// المسار: features/profile/presentation/pages/settings_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • SettingsPage
//   • _SettingsPageState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/usecases/send_password_reset.dart';
/// شاشة الإعدادات.
class SettingsPage extends StatefulWidget {
  /// دالة الإعدادات صفحة.
  const SettingsPage({super.key});

  @override
  /// ينشئ الحالة.
  State<SettingsPage> createState() => _SettingsPageState();
}

/// حالة واجهة الإعدادات صفحة.
class _SettingsPageState extends State<SettingsPage> {
  bool _sendingReset = false;

  /// دالة داخلية: on إعادة تعيين كلمة المرور tap.
  Future<void> _onResetPasswordTap() async {
    if (_sendingReset) return;
    final email = getIt<AuthRepository>().currentUser?.email?.trim();
    if (email == null || email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        /// دالة snack شريط.
        const SnackBar(
          content: Text('لا يوجد بريد إلكتروني مرتبط بالحساب.'),
          backgroundColor: AppColors.surface,
        ),
      );
      return;
    }

  /// يعيّن الحالة.
    setState(() => _sendingReset = true);
    try {
      await getIt<SendPasswordReset>().call(email);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('تم'),
          content: const Text(
            'تم ارسال ايميل الى حسابك لتغير كلمه السر',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          actions: [
          /// دالة نص زر.
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
      /// دالة snack شريط.
        SnackBar(
          content: Text(
            e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'تعذر إرسال البريد',
          ),
          backgroundColor: AppColors.surface,
        ),
      );
    } finally {
      if (mounted) setState(() => _sendingReset = false);
    }
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        title: const Text('الإعدادات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// دالة sized box.
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _sendingReset ? null : _onResetPasswordTap,
              icon: _sendingReset
                  /// دالة sized box.
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock_reset),
              label: const Text('تغيير كلمة السر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            /// دالة sized box.
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
