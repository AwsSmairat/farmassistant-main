import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../di/injection.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/robot/presentation/pages/robot_control_page.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create() {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final user = getIt<AuthRepository>().currentUser;
        final location = state.matchedLocation;
        final isAuthRoute = location == '/login' || location == '/signup' || location == '/forgot-password';
        final isAdmin = AppConstants.isAdminEmail(user?.email);

        if (user == null) {
          if (!isAuthRoute) return '/login';
          return null;
        }

        if (isAuthRoute) {
          return isAdmin ? '/admin' : '/';
        }

        if (location == '/admin' && !isAdmin) return '/';
        if (location == '/' && isAdmin) return '/admin';
        if (location == '/robot-control') return '/?tab=robot';
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
          builder: (context, state) {
            final tab = state.uri.queryParameters['tab'];
            final index = AppRouter._tabToIndex(tab);
            return HomeShellPage(initialIndex: index);
          },
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: '/robot-control',
          builder: (context, state) =>
              const RobotControlPage(showBackButton: true),
        ),
      ],
    );
  }

  static int _tabToIndex(String? tab) {
    switch (tab) {
      case 'robot':
        return 1;
      case 'sensors':
        return 2;
      case 'alerts':
        return 3;
      case 'profile':
        return 4;
      default:
        return 0;
    }
  }
}
