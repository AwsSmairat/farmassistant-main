// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_remote_datasource.dart
// المسار: features/sensors/data/datasources/sensors_remote_datasource.dart
// الطبقة: data / datasources — مصدر بيانات
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. الاتصال بـ Firebase أو API.
//
// ماذا بداخله؟
//   • SensorsRemoteDatasource
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import '../../domain/entities/sensors_snapshot.dart';
/// مصدر بيانات المستشعرات بعيد مصدر بيانات.
abstract class SensorsRemoteDatasource {
  /// يراقب بثاً مباشراً لـ المستشعرات.
  Stream<SensorsSnapshot> watchSensors();
}
