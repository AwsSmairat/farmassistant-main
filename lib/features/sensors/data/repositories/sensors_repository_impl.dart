// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_repository_impl.dart
// المسار: features/sensors/data/repositories/sensors_repository_impl.dart
// الطبقة: data / repositories — تنفيذ المستودع
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. تنفيذ واجهة المستودع — واجهة أو تنفيذ طبقة البيانات.
//
// ماذا بداخله؟
//   • SensorsRepositoryImpl
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/sensors_snapshot.dart';
import '../../domain/repositories/sensors_repository.dart';
import '../datasources/sensors_remote_datasource.dart';

/// تنفيذ مستودع المستشعرات.
class SensorsRepositoryImpl implements SensorsRepository {
  SensorsRepositoryImpl(this._datasource);

  /// حقل: مصدر بيانات.
  final SensorsRemoteDatasource _datasource;

  @override
  /// يراقب بثاً مباشراً لـ المستشعرات.
  Stream<SensorsSnapshot> watchSensors() => _datasource.watchSensors();
}
