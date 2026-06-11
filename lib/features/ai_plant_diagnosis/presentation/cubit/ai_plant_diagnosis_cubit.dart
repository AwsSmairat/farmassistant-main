// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_plant_diagnosis_cubit.dart
// المسار: features/ai_plant_diagnosis/presentation/cubit/ai_plant_diagnosis_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • AiPlantDiagnosisCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/failures/plant_diagnosis_failure.dart';
import '../../domain/usecases/analyze_plant_image.dart';
import '../../domain/usecases/save_ai_diagnosis_record.dart';
import 'ai_plant_diagnosis_state.dart';

/// منطق الواجهة (Cubit) لـ الذكاء الاصطناعي النبات التشخيص.
class AiPlantDiagnosisCubit extends Cubit<AiPlantDiagnosisState> {
  AiPlantDiagnosisCubit({
    required AnalyzePlantImage analyzePlantImage,
    required SaveAiDiagnosisRecord saveAiDiagnosisRecord,
    ImagePicker? imagePicker,
  })  : _analyzePlantImage = analyzePlantImage,
        _saveAiDiagnosisRecord = saveAiDiagnosisRecord,
        _picker = imagePicker ?? ImagePicker(),
      /// دالة super.
        super(const AiPlantDiagnosisState());

  /// حقل: تحليل النبات الصورة.
  final AnalyzePlantImage _analyzePlantImage;
  /// حقل: حفظ الذكاء الاصطناعي التشخيص سجل.
  final SaveAiDiagnosisRecord _saveAiDiagnosisRecord;
  /// حقل: picker.
  final ImagePicker _picker;

  /// دالة إعادة تعيين.
  void reset() => emit(const AiPlantDiagnosisState());

  /// يمسح الصورة.
  void clearImage() {
  /// يصدّر حالة جديدة.
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

  /// دالة pick from gallery.
  Future<void> pickFromGallery() async {
    try {
      if (kIsWeb) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );
        if (result == null || result.files.isEmpty) return;
        final picked = result.files.single;
        final bytes = picked.bytes;
        if (bytes == null) {
        /// يصدّر حالة جديدة.
          emit(
            state.copyWith(
              phase: AiPlantDiagnosisPhase.error,
              errorMessage:
                  'تعذر قراءة الصورة من المتصفح. جرّب صورة أصغر أو متصفحاً آخر.',
              clearSaveWarning: true,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            image: XFile.fromData(bytes, name: picked.name),
            phase: AiPlantDiagnosisPhase.imageReady,
            clearResult: true,
            clearError: true,
            clearSaveWarning: true,
          ),
        );
        return;
      }

      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 82,
        requestFullMetadata: false,
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
          errorMessage: kIsWeb
              ? 'تعذر فتح اختيار الصور في المتصفح. تأكد أنك على رابط آمن (https)، وجرّب متصفحاً آخر أو اسمح بالوصول من إعدادات الموقع.'
              : 'تعذر فتح المعرض. تحقق من الأذونات وحاول مرة أخرى.',
          clearSaveWarning: true,
        ),
      );
    }
  }

  /// دالة pick from الكاميرا.
  Future<void> pickFromCamera() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 82,
        requestFullMetadata: false,
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
          errorMessage: kIsWeb
              ? 'تعذر فتح الكاميرا من المتصفح. اسمح بالكاميرا لهذا الموقع من إعدادات المتصفح، أو اختر صورة من المعرض.'
              : 'تعذر فتح الكاميرا. تحقق من الأذونات وحاول مرة أخرى.',
          clearSaveWarning: true,
        ),
      );
    }
  }

  /// يحلّل.
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

  /// يصدّر حالة جديدة.
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
          /// دالة داخلية: حفظ الذكاء الاصطناعي التشخيص سجل.
          await _saveAiDiagnosisRecord(result: result, image: image);
        } on PlantDiagnosisFailure catch (e) {
          saveWarning = plantDiagnosisFailureMessageAr(e.reason);
        } catch (_) {
          saveWarning =
              'تم التحليل لكن تعذر حفظ السجل في السحابة. تحقق من الاتصال أو قواعد Firebase.';
        }
      }
      emit(
      /// دالة الذكاء الاصطناعي النبات التشخيص الحالة.
        AiPlantDiagnosisState(
          image: image,
          phase: AiPlantDiagnosisPhase.success,
          result: result,
          saveWarning: saveWarning,
        ),
      );
    } on PlantDiagnosisFailure catch (e) {
      emit(
      /// دالة الذكاء الاصطناعي النبات التشخيص الحالة.
        AiPlantDiagnosisState(
          image: image,
          phase: AiPlantDiagnosisPhase.error,
          errorMessage: plantDiagnosisFailureMessageAr(e.reason),
        ),
      );
    } catch (e) {
      emit(
      /// دالة الذكاء الاصطناعي النبات التشخيص الحالة.
        AiPlantDiagnosisState(
          image: image,
          phase: AiPlantDiagnosisPhase.error,
          errorMessage: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        ),
      );
    }
  }
}
