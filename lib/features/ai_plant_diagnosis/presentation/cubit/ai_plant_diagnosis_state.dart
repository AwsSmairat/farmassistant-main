import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';

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

class AiPlantDiagnosisState extends Equatable {
  const AiPlantDiagnosisState({
    this.image,
    this.phase = AiPlantDiagnosisPhase.awaitingImage,
    this.result,
    this.errorMessage,
    this.saveWarning,
  });

  final XFile? image;
  final AiPlantDiagnosisPhase phase;
  final PlantDiagnosisResult? result;
  final String? errorMessage;

  /// Non-null when analysis succeeded but Firestore/Storage save failed.
  final String? saveWarning;

  bool get hasImage => image != null;

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
  List<Object?> get props => [
    image?.path,
    phase,
    result,
    errorMessage,
    saveWarning,
  ];
}
