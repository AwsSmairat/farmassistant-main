import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../theme/app_colors.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create() {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final user = getIt<AuthRepository>().currentUser;
        final location = state.matchedLocation;
        final isAuthRoute = location == '/login' || location == '/signup' || location == '/forgot-password';
        if (user == null && !isAuthRoute) return '/login';
        if (user != null && isAuthRoute) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<LoginCubit>()..reset(),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SignupCubit>()..reset(),
            child: const SignupPage(),
          ),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ForgotPasswordCubit>()..reset(),
            child: const ForgotPasswordPage(),
          ),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const _PlaceholderHome(),
        ),
      ],
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً، تم تسجيل الدخول'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                await getIt<SignOut>().call();
                if (context.mounted) context.go('/login');
              },
              child: const Text('تسجيل الخروج والعودة لتسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}
