import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/usecases/sign_out.dart';

/// Toolbar action: signs out via [SignOut] then navigates to login.
///
/// Uses [GoRouter.refresh], [SchedulerBinding.scheduleFrame], and a post-frame
/// [go] so Flutter Web repaints immediately (avoids “works after another tap”).
class LogoutIconButton extends StatefulWidget {
  const LogoutIconButton({super.key});

  @override
  State<LogoutIconButton> createState() => _LogoutIconButtonState();
}

class _LogoutIconButtonState extends State<LogoutIconButton> {
  bool _busy = false;

  Future<void> _signOut() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await getIt<SignOut>().call();
      if (!mounted) return;

      final router = GoRouter.of(context);
      router.refresh();
      SchedulerBinding.instance.scheduleFrame();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        router.go('/login');
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذّر تسجيل الخروج. حاول مرة أخرى.'),
          backgroundColor: AppColors.surface,
        ),
      );
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'تسجيل الخروج',
      icon: _busy
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
