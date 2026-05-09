import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/diagnosis_record.dart';
import '../../domain/usecases/watch_diagnosis_history.dart';
import 'diagnosis_history_state.dart';

class DiagnosisHistoryCubit extends Cubit<DiagnosisHistoryState> {
  DiagnosisHistoryCubit(this._watchDiagnosisHistory)
      : super(const DiagnosisHistoryInitial());

  final WatchDiagnosisHistory _watchDiagnosisHistory;
  StreamSubscription<List<DiagnosisRecord>>? _sub;

  void start() {
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
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
