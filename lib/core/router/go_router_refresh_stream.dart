// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: go_router_refresh_stream.dart
// المسار: core/router/go_router_refresh_stream.dart
// الطبقة: core / router — التنقل
//
// ماذا يفعل؟
//   تعريف مسارات التطبيق.
//
// ماذا بداخله؟
//   • GoRouterRefreshStream
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:async';

import 'package:flutter/foundation.dart';
/// كلاس go التوجيه تحديث البث.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  /// حقل: subscription.
  late final StreamSubscription<dynamic> _subscription;

  @override
  /// ينظف الموارد.
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
