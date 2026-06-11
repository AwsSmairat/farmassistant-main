// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: mock_ai_diagnosis_service.dart
// المسار: features/ai_plant_diagnosis/data/services/mock_ai_diagnosis_service.dart
// الطبقة: data / services — خدمة بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. خدمة تنفيذ منطق أو اتصال خارجي.
//
// ماذا بداخله؟
//   • MockAiDiagnosisService
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:math';

import 'package:image_picker/image_picker.dart';

import '../../domain/entities/plant_diagnosis_result.dart';
import '../../domain/services/ai_diagnosis_service.dart';
/// خدمة وهمي الذكاء الاصطناعي التشخيص.
class MockAiDiagnosisService implements AiDiagnosisService {
  MockAiDiagnosisService({Random? random}) : _random = random ?? Random();

  /// حقل: random.
  final Random _random;

  static const _diseases = <({String en, String ar, String treatment, String explanation})>[
    (
      en: 'Early blight',
      ar: 'اللفحة المبكرة',
      treatment:
          'أزل الأوراق المصابة بعناية، حسّن التهوية بين النباتات، وتجنب الري على الأوراق. طبّق مبيد فطري يحتوي الأزوكسستروبين أو الكلوروثالونيل وفق تعليمات الملصق، مع تناوب آليات المفعول.',
      explanation:
          'تظهر بقع قاتمة متحدة على الأوراق القديمة مع حلقات متحدة المركز؛ النموذج المحاكي يطابق أنماط اللفحة المبكرة الشائعة.',
    ),
    (
      en: 'Powdery mildew',
      ar: 'البياض الدقيقي',
      treatment:
          'قلل الكثافة الورقية قليلاً، رش بمحلول بيكربونات أو كبريتات قابلة للاستخدام الزراعي، وراقب الرطوبة الليلية. في الإصابات الشديدة استخدم مبيد فطري جهازي موصى به محلياً.',
      explanation:
          'طبقة بيضاء بودرية على السطح العلوي للورقة تشير غالباً للبياض الدقيقي؛ راقب التهوية والرطوبة النسبية.',
    ),
    (
      en: 'Leaf spot',
      ar: 'تبقع الأوراق',
      treatment:
          'تخلص من بقايا النبات في نهاية الموسم، رش نحاسي وقائي عند ظهور أول بقع، واضبط الري ليبقى المجتمع المائي على مستوى مناسب فقط.',
      explanation:
          'بقع صغيرة محددة مع تحول لون الأنسجة؛ قد يكون فطرياً أو جرثومياً — التشخيص المحاكي يفترض تبقعاً فطرياً شائعاً.',
    ),
  ];

  @override
  /// يحلّل النبات الصورة.
  Future<PlantDiagnosisResult> analyzePlantImage(XFile image) async {
    await Future<void>.delayed(
    /// دالة duration.
      Duration(milliseconds: 900 + _random.nextInt(1100)),
    );

    final bytes = await image.readAsBytes();
    final fingerprint = bytes.isEmpty ? 0 : bytes.reduce((a, b) => a + b);
    final bucket = fingerprint % 100;

    final analyzedAt = DateTime.now();

    if (bucket < 38) {
      return PlantDiagnosisResult(
        condition: PlantDiagnosisCondition.healthy,
        resultFirestoreLabel: 'Healthy',
        confidence: 0.78 + _random.nextDouble() * 0.18,
        treatmentAr:
            'النبات يبدو سليماً. استمر بالري المتوازن، تغذية خفيفة دورية، ومراقبة أسبوعية للأوراق الجديدة.',
        analyzedAt: analyzedAt,
        explanation:
            'لم يُلاحظ على الصورة نمط واضح للأمراض الشائعة؛ النسخة المحاكية تعتبر النسيج سليماً بثقة معتدلة.',
      );
    }

    if (bucket < 52) {
      return PlantDiagnosisResult(
        condition: PlantDiagnosisCondition.noPathogenDetected,
        resultFirestoreLabel: 'Healthy',
        confidence: 0.72 + _random.nextDouble() * 0.15,
        treatmentAr:
            'لم يُظهر النموذج توقيعاً واضحاً لمرض محدد. راقب النبات لبضعة أيام، وحسّن الإضاءة والتهوية كإجراء وقائي.',
        analyzedAt: analyzedAt,
        explanation:
            'الصورة لا تحمل دلائل قاطعة لمرض؛ يُنصح بمراقبة دورية وتحسين الظروف البيئية.',
      );
    }

    final pick = _diseases[fingerprint % _diseases.length];
    return PlantDiagnosisResult(
      condition: PlantDiagnosisCondition.diseased,
      resultFirestoreLabel: pick.en,
      diseaseNameAr: pick.ar,
      diseaseName: pick.en,
      confidence: 0.68 + _random.nextDouble() * 0.25,
      treatmentAr: pick.treatment,
      explanation: pick.explanation,
      analyzedAt: analyzedAt,
    );
  }
}
