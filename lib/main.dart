// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: main.dart
// المسار: main.dart
// الطبقة: جذر التطبيق
//
// ماذا يفعل؟
//   نقطة بدء تشغيل التطبيق.
//
// ماذا بداخله؟
//   • FarmAssistantApp
//   • _FarmAssistantAppState
//   • main()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/router/go_router_refresh_stream.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/liquid_glass/liquid_glass.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
  /// دالة use path url strategy.
    usePathUrlStrategy();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /// يُعد حقن التبعيات.
  await setupInjection();
  if (kIsWeb) {
    await getIt<AuthRepository>().completeWebRedirectSignInIfNeeded();
  }
  runApp(const FarmAssistantApp());
}

/// كلاس المزرعة assistant التطبيق.
class FarmAssistantApp extends StatefulWidget {
  /// دالة المزرعة assistant التطبيق.
  const FarmAssistantApp({super.key});

  @override
  /// ينشئ الحالة.
  State<FarmAssistantApp> createState() => _FarmAssistantAppState();
}

/// حالة واجهة المزرعة assistant التطبيق.
class _FarmAssistantAppState extends State<FarmAssistantApp> {
  /// حقل: المصادقة تحديث.
  late final GoRouterRefreshStream _authRefresh;
  /// حقل: التوجيه.
  late final GoRouter _router;

  @override
  /// يهيّئ الويدجت.
  void initState() {
    super.initState();
    _authRefresh = GoRouterRefreshStream(getIt<AuthRepository>().authStateChanges);
    _router = AppRouter.create(refreshListenable: _authRefresh);
  }

  @override
  /// ينظف الموارد.
  void dispose() {
    _authRefresh.dispose();
    super.dispose();
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Farm Assistant',
      theme: AppTheme.dark,
      locale: const Locale('ar'),
      supportedLocales: const [
      /// دالة locale.
        Locale('ar'),
      /// دالة locale.
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: LiquidGlassAppBackground(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      routerConfig: _router,
    );
  }
}
