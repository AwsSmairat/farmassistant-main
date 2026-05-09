import 'package:equatable/equatable.dart';

import '../../domain/entities/diagnosis_record.dart';

sealed class DiagnosisHistoryState extends Equatable {
  const DiagnosisHistoryState();

  @override
  List<Object?> get props => [];
}

final class DiagnosisHistoryInitial extends DiagnosisHistoryState {
  const DiagnosisHistoryInitial();
}

final class DiagnosisHistoryLoading extends DiagnosisHistoryState {
  const DiagnosisHistoryLoading();
}

final class DiagnosisHistoryReady extends DiagnosisHistoryState {
  const DiagnosisHistoryReady(this.records);

  final List<DiagnosisRecord> records;

  @override
  List<Object?> get props => [records];
}

final class DiagnosisHistoryFailure extends DiagnosisHistoryState {
  const DiagnosisHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
