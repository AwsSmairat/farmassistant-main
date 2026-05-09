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
    usePathUrlStrategy();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupInjection();
  if (kIsWeb) {
    await getIt<AuthRepository>().completeWebRedirectSignInIfNeeded();
  }
  runApp(const FarmAssistantApp());
}

class FarmAssistantApp extends StatefulWidget {
  const FarmAssistantApp({super.key});

  @override
  State<FarmAssistantApp> createState() => _FarmAssistantAppState();
}

class _FarmAssistantAppState extends State<FarmAssistantApp> {
  late final GoRouterRefreshStream _authRefresh;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authRefresh = GoRouterRefreshStream(getIt<AuthRepository>().authStateChanges);
    _router = AppRouter.create(refreshListenable: _authRefresh);
  }

  @override
  void dispose() {
    _authRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Farm Assistant',
      theme: AppTheme.dark,
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
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
