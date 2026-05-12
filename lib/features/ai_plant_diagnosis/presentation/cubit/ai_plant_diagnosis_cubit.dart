import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/failures/plant_diagnosis_failure.dart';
import '../../domain/usecases/analyze_plant_image.dart';
import '../../domain/usecases/save_ai_diagnosis_record.dart';
import 'ai_plant_diagnosis_state.dart';

class AiPlantDiagnosisCubit extends Cubit<AiPlantDiagnosisState> {
  AiPlantDiagnosisCubit({
    required AnalyzePlantImage analyzePlantImage,
    required SaveAiDiagnosisRecord saveAiDiagnosisRecord,
    ImagePicker? imagePicker,
  })  : _analyzePlantImage = analyzePlantImage,
        _saveAiDiagnosisRecord = saveAiDiagnosisRecord,
        _picker = imagePicker ?? ImagePicker(),
        super(const AiPlantDiagnosisState());

  final AnalyzePlantImage _analyzePlantImage;
  final SaveAiDiagnosisRecord _saveAiDiagnosisRecord;
  final ImagePicker _picker;

  void reset() => emit(const AiPlantDiagnosisState());

  void clearImage() {
    emit(
      state.copyWith(
        clearImage: true,
        clearResult: true,
        clearError: true,
        clearSaveWarning: true,
        phase: AiPlantDiagnosisPhase.awaitingImage,
      ),
    );
  }

  Future<void> pickFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 82,
      );
      if (file == null) return;
      emit(
        state.copyWith(
          image: file,
          phase: AiPlantDiagnosisPhase.imageReady,
          clearResult: true,
          clearError: true,
          clearSaveWarning: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          phase: AiPlantDiagnosisPhase.error,
          errorMessage: 'تعذر فتح المعرض. تحقق من الأذونات وحاول مرة أخرى.',
          clearSaveWarning: true,
        ),
      );
    }
  }

  Future<void> pickFromCamera() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 82,
      );
      if (file == null) return;
      emit(
        state.copyWith(
          image: file,
          phase: AiPlantDiagnosisPhase.imageReady,
          clearResult: true,
          clearError: true,
          clearSaveWarning: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          phase: AiPlantDiagnosisPhase.error,
          errorMessage: 'تعذر فتح الكاميرا. تحقق من الأذونات وحاول مرة أخرى.',
          clearSaveWarning: true,
        ),
      );
    }
  }

  Future<void> analyze() async {
    final image = state.image;
    if (image == null) {
      emit(
        state.copyWith(
          phase: AiPlantDiagnosisPhase.error,
          errorMessage: 'يرجى اختيار صورة نبات أولاً.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        phase: AiPlantDiagnosisPhase.analyzing,
        clearError: true,
        clearSaveWarning: true,
        clearResult: true,
      ),
    );

    try {
      final result = await _analyzePlantImage(image);
      String? saveWarning;
      if (!result.persistedByCloud) {
        try {
          await _saveAiDiagnosisRecord(result: result, image: image);
        } on PlantDiagnosisFailure catch (e) {
          saveWarning = plantDiagnosisFailureMessageAr(e.reason);
        } catch (_) {
          saveWarning =
              'تم التحليل لكن تعذر حفظ السجل في السحابة. تحقق من الاتصال أو قواعد Firebase.';
        }
      }
      emit(
        AiPlantDiagnosisState(
          image: image,
          phase: AiPlantDiagnosisPhase.success,
          result: result,
          saveWarning: saveWarning,
        ),
      );
    } on PlantDiagnosisFailure catch (e) {
      emit(
        AiPlantDiagnosisState(
          image: image,
          phase: AiPlantDiagnosisPhase.error,
          errorMessage: plantDiagnosisFailureMessageAr(e.reason),
        ),
      );
    } catch (e) {
      emit(
        AiPlantDiagnosisState(
          image: image,
          phase: AiPlantDiagnosisPhase.error,
          errorMessage: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        ),
      );
    }
  }
}
