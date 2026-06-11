// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_router.dart
// المسار: core/router/app_router.dart
// الطبقة: core / router — التنقل
//
// ماذا يفعل؟
//   تعريف مسارات التطبيق.
//
// ماذا بداخله؟
//   • AppRouter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/foundation.dart' show Listenable;
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
import '../../features/diagnosis/presentation/cubit/diagnosis_history_cubit.dart';
import '../../features/diagnosis/presentation/pages/diagnosis_history_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/robot/presentation/cubit/robot_control_cubit.dart';
import '../../features/robot/presentation/pages/robot_control_page.dart';

/// كلاس التطبيق التوجيه.
class AppRouter {
  AppRouter._();

  /// ينشئ.
  static GoRouter create({Listenable? refreshListenable}) {
    return GoRouter(
      refreshListenable: refreshListenable,
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
      /// دالة go route.
        GoRoute(
          path: '/login',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<LoginCubit>()..reset(),
            child: const LoginPage(),
          ),
        ),
      /// دالة go route.
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SignupCubit>()..reset(),
            child: const SignupPage(),
          ),
        ),
      /// دالة go route.
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ForgotPasswordCubit>()..reset(),
            child: const ForgotPasswordPage(),
          ),
        ),
      /// دالة go route.
        GoRoute(
          path: '/',
          builder: (context, state) {
            final tab = state.uri.queryParameters['tab'];
            final index = AppRouter._tabToIndex(tab);
            /// دالة الرئيسية الهيكل الرئيسي صفحة.
            return HomeShellPage(initialIndex: index);
          },
        ),
      /// دالة go route.
        GoRoute(
          path: '/diagnosis',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<DiagnosisHistoryCubit>()..start(),
            child: const DiagnosisHistoryPage(),
          ),
        ),
      /// دالة go route.
        GoRoute(
          path: '/robot-control',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<RobotControlCubit>(),
            child: const RobotControlPage(showBackButton: true),
          ),
        ),
      /// دالة go route.
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      /// دالة go route.
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
      ],
    );
  }

  /// دالة داخلية: tab to index.
  static int _tabToIndex(String? tab) {
  /// دالة switch.
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
