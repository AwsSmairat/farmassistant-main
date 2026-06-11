// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: diagnosis_history_cubit.dart
// المسار: features/diagnosis/presentation/cubit/diagnosis_history_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: سجل تشخيص النبات. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • DiagnosisHistoryCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/diagnosis_record.dart';
import '../../domain/usecases/watch_diagnosis_history.dart';
import 'diagnosis_history_state.dart';

/// منطق الواجهة (Cubit) لـ التشخيص السجل.
class DiagnosisHistoryCubit extends Cubit<DiagnosisHistoryState> {
  DiagnosisHistoryCubit(this._watchDiagnosisHistory)
      : super(const DiagnosisHistoryInitial());

  /// حقل: مراقبة التشخيص السجل.
  final WatchDiagnosisHistory _watchDiagnosisHistory;
  StreamSubscription<List<DiagnosisRecord>>? _sub;

  /// يبدأ.
  void start() {
  /// يصدّر حالة جديدة.
    emit(const DiagnosisHistoryLoading());
    _sub?.cancel();
    _sub = _watchDiagnosisHistory(limit: 50).listen(
      (records) {
        emit(DiagnosisHistoryReady(records));
      },
      onError: (Object e, _) {
        emit(DiagnosisHistoryFailure(
          e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
        ));
      },
    );
  }

  @override
  /// يغلق.
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
