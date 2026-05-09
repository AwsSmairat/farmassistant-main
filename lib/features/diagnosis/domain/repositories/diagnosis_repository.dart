import '../entities/diagnosis_record.dart';

abstract class DiagnosisRepository {
  Stream<List<DiagnosisRecord>> watchHistory({int limit});
}
