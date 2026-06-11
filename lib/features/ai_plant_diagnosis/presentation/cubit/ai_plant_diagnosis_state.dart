// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_plant_diagnosis_state.dart
// المسار: features/ai_plant_diagnosis/presentation/cubit/ai_plant_diagnosis_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • AiPlantDiagnosisState
//   • enum AiPlantDiagnosisPhase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';

/// تعداد الذكاء الاصطناعي النبات التشخيص phase.
enum AiPlantDiagnosisPhase {
  /// No image yet (empty state).
  awaitingImage,

  /// User picked an image, not yet analyzed.
  imageReady,

  /// Inference + save in progress.
  analyzing,

  /// Completed analysis (includes healthy / diseased / no pathogen).
  success,

  /// Recoverable failure (picker, network, Firestore, etc.).
  error,
}

/// حالة واجهة الذكاء الاصطناعي النبات التشخيص.
class AiPlantDiagnosisState extends Equatable {
  /// دالة الذكاء الاصطناعي النبات التشخيص الحالة.
  const AiPlantDiagnosisState({
    this.image,
    this.phase = AiPlantDiagnosisPhase.awaitingImage,
    this.result,
    this.errorMessage,
    this.saveWarning,
  });

  /// حقل: الصورة.
  final XFile? image;
  /// حقل: phase.
  final AiPlantDiagnosisPhase phase;
  /// حقل: نتيجة.
  final PlantDiagnosisResult? result;
  /// حقل: خطأ message.
  final String? errorMessage;

  /// Non-null when analysis succeeded but Firestore/Storage save failed.
  /// حقل: حفظ warning.
  final String? saveWarning;

  /// يُرجع has الصورة.
  bool get hasImage => image != null;

  /// ينسخ الكائن مع تعديل بعض الحقول.
  AiPlantDiagnosisState copyWith({
    XFile? image,
    bool clearImage = false,
    AiPlantDiagnosisPhase? phase,
    PlantDiagnosisResult? result,
    bool clearResult = false,
    String? errorMessage,
    bool clearError = false,
    String? saveWarning,
    bool clearSaveWarning = false,
  }) {
    return AiPlantDiagnosisState(
      image: clearImage ? null : (image ?? this.image),
      phase: phase ?? this.phase,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      saveWarning: clearSaveWarning ? null : (saveWarning ?? this.saveWarning),
    );
  }

  @override
  /// يُرجع props.
  List<Object?> get props => [
    image?.path,
    phase,
    result,
    errorMessage,
    saveWarning,
  ];
}
