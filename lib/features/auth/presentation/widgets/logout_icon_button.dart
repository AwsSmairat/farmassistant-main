import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/usecases/sign_out.dart';

/// Toolbar action: signs out via [SignOut] then navigates to login (RTL-safe tap target).
class LogoutIconButton extends StatelessWidget {
  const LogoutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'تسجيل الخروج',
      icon: const Icon(Icons.logout),
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      onPressed: () => _signOut(context),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await getIt<SignOut>().call();
      if (!context.mounted) return;
      context.go('/login');
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذّر تسجيل الخروج. حاول مرة أخرى.'),
          backgroundColor: AppColors.surface,
        ),
      );
    }
  }
}
