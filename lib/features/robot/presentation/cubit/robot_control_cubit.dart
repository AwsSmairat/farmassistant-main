// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_control_cubit.dart
// الطبقة: presentation / cubit

// ماذا يفعل؟
//   يدير منطق شاشة التحكم بالروبوت:
//   يستمع لحالة Firestore ويرسل الأوامر ويحدّث الواجهة.

// ماذا بداخله؟
//   • RobotControlCubit — Cubit الرئيسي (Bloc)
//   • start() — بدء الاستماع لـ robot_status
//   • sendMove / sendStop — أوامر الحركة
//   • setPump / togglePump — التحكم بالمضخة
//   • toggleAutoMode — الوضع التلقائي
//   • requestGpsRefresh() — تحديث GPS
//   • _run() — تنفيذ أمر مع مؤشر تحميل ومعالجة أخطاء
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/robot_command_service.dart';
import '../../domain/entities/robot_live_status.dart';
import 'robot_control_state.dart';

/// منطق شاشة التحكم بالروبوت: الاستماع للحالة وإرسال الأوامر.
class RobotControlCubit extends Cubit<RobotControlState> {
  RobotControlCubit(this._commands) : super(const RobotControlState());

  final RobotCommandService _commands;
  StreamSubscription<RobotLiveStatus>? _statusSub;

  /// بدء الاستماع المباشر لـ robot_status/robot_001.
  void start() {
    _statusSub?.cancel();
    _statusSub = _commands.watchRobotStatus().listen(
      _onStatus,
      onError: (_) {
        emit(
          state.copyWith(
            isFirestoreConnected: false,
            errorMessage: 'انقطع الاتصال بـ Firestore',
          ),
        );
      },
    );
  }

  /// تحديث الحالة عند وصول لقطة جديدة من Firestore.
  void _onStatus(RobotLiveStatus status) {
    emit(
      state.copyWith(
        isFirestoreConnected: true,
        status: status,
        waterPumpOn: status.pump ?? state.waterPumpOn,
        autoModeOn: status.autoMode ?? state.autoModeOn,
        gpsLabel: status.gpsLabel ?? state.gpsLabel,
        clearError: true,
      ),
    );
  }

  /// إرسال أمر حركة (forward, backward, left, right).
  Future<void> sendMove(String direction) => _run(() => _commands.sendMove(direction));

  /// إيقاف الروبوت فوراً.
  Future<void> sendStop() => sendMove('stop');

  /// تعيين حالة المضخة وإرسالها إلى Firestore.
  Future<void> setPump(bool on) async {
    emit(state.copyWith(waterPumpOn: on, clearError: true));
    await _run(() => _commands.sendPump(on));
  }

  /// تبديل حالة المضخة.
  Future<void> togglePump() => setPump(!state.waterPumpOn);

  /// تبديل الوضع التلقائي.
  Future<void> toggleAutoMode() async {
    final next = !state.autoModeOn;
    emit(state.copyWith(autoModeOn: next, clearError: true));
    await _run(() => _commands.sendAutoMode(next));
  }

  /// طلب تحديث إحداثيات GPS.
  Future<void> requestGpsRefresh() => _run(() => _commands.requestGpsRefresh());

  /// تنفيذ أمر مع مؤشر تحميل ومعالجة الأخطاء.
  Future<void> _run(Future<void> Function() action) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await action();
      emit(state.copyWith(isLoading: false, clearError: true));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'تعذر إرسال الأمر إلى Firestore',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _statusSub?.cancel();
    return super.close();
  }
}
