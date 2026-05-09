import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/diagnosis/presentation/pages/diagnosis_history_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/robot/presentation/pages/robot_control_page.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create() {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final user = getIt<AuthRepository>().currentUser;
        final location = state.matchedLocation;
        final isAuthRoute =
            location == '/login' || location == '/signup' || location == '/forgot-password';

        if (user == null) {
          if (!isAuthRoute) return '/login';
          return null;
        }

        if (isAuthRoute) {
          return '/';
        }

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
          path: '/diagnosis',
          builder: (context, state) => const DiagnosisHistoryPage(),
        ),
        GoRoute(
          path: '/robot-control',
          builder: (context, state) =>
              const RobotControlPage(showBackButton: true),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
      ],
    );
  }

  static int _tabToIndex(String? tab) {
    switch (tab) {
      case 'robot':
        return 2;
      case 'sensors':
        return 1;
      case 'alerts':
        return 3;
      case 'profile':
        return 4;
      default:
        return 0;
    }
  }
}
