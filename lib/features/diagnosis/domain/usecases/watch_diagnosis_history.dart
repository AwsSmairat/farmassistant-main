import '../entities/diagnosis_record.dart';
import '../repositories/diagnosis_repository.dart';

class WatchDiagnosisHistory {
  WatchDiagnosisHistory(this._repository);

  final DiagnosisRepository _repository;

  Stream<List<DiagnosisRecord>> call({int limit = 50}) =>
      _repository.watchHistory(limit: limit);
}
