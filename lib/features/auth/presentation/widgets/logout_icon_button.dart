// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: logout_icon_button.dart
// المسار: features/auth/presentation/widgets/logout_icon_button.dart
// الطبقة: presentation / widgets — مكوّن واجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • LogoutIconButton
//   • _LogoutIconButtonState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/usecases/sign_out.dart';

/// Toolbar action: signs out via [SignOut] then navigates to login.
///
/// Relies on [AuthRemoteDatasource.signOut] waiting until Firebase reports a null
/// مكوّن واجهة: تسجيل خروج أيقونة زر.
class LogoutIconButton extends StatefulWidget {
  /// دالة تسجيل خروج أيقونة زر.
  const LogoutIconButton({super.key});

  @override
  /// ينشئ الحالة.
  State<LogoutIconButton> createState() => _LogoutIconButtonState();
}

/// حالة واجهة تسجيل خروج أيقونة زر.
class _LogoutIconButtonState extends State<LogoutIconButton> {
  bool _busy = false;

  /// دالة داخلية: تسجيل خروج.
  Future<void> _signOut() async {
    if (_busy) return;
  /// يعيّن الحالة.
    setState(() => _busy = true);
    try {
      await getIt<SignOut>().call();
      if (!mounted) return;

      final router = GoRouter.of(context);
      router.refresh();
      router.go('/login');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        /// دالة snack شريط.
        const SnackBar(
          content: Text('تعذّر تسجيل الخروج. حاول مرة أخرى.'),
          backgroundColor: AppColors.surface,
        ),
      );
      setState(() => _busy = false);
    }
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'تسجيل الخروج',
      icon: _busy
          /// دالة sized box.
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : const Icon(Icons.logout),
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      onPressed: _busy ? null : _signOut,
    );
  }
}
