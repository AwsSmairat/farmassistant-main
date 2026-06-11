// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: diagnosis_history_state.dart
// المسار: features/diagnosis/presentation/cubit/diagnosis_history_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: سجل تشخيص النبات. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • diagnosis_history_state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

import '../../domain/entities/diagnosis_record.dart';

sealed class DiagnosisHistoryState extends Equatable {
  /// دالة التشخيص السجل الحالة.
  const DiagnosisHistoryState();

  @override
  /// يُرجع props.
  List<Object?> get props => [];
}

final class DiagnosisHistoryInitial extends DiagnosisHistoryState {
  /// دالة التشخيص السجل initial.
  const DiagnosisHistoryInitial();
}

final class DiagnosisHistoryLoading extends DiagnosisHistoryState {
  /// دالة التشخيص السجل تحميل.
  const DiagnosisHistoryLoading();
}

final class DiagnosisHistoryReady extends DiagnosisHistoryState {
  /// دالة التشخيص السجل ready.
  const DiagnosisHistoryReady(this.records);

  /// حقل: records.
  final List<DiagnosisRecord> records;

  @override
  /// يُرجع props.
  List<Object?> get props => [records];
}

final class DiagnosisHistoryFailure extends DiagnosisHistoryState {
  /// دالة التشخيص السجل فشل.
  const DiagnosisHistoryFailure(this.message);

  /// حقل: message.
  final String message;

  @override
  /// يُرجع props.
  List<Object?> get props => [message];
}
