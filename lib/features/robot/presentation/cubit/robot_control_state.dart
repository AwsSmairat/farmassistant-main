// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: robot_control_state.dart
// الطبقة: presentation / cubit

// ماذا يفعل؟
//   يحدد شكل الحالة التي تعرضها شاشة التحكم بالروبوت
//   (ما يقرأه BlocBuilder من Cubit).

// ماذا بداخله؟
//   • RobotControlState — حالة الشاشة
//   • waterPumpOn, autoModeOn, isLoading, isFirestoreConnected
//   • status — لقطة RobotLiveStatus من Firestore
//   • gpsLabel, errorMessage
//   • robotOnline — هل الروبوت متصل؟
//   • cameraStreamUrl — رابط بث الكاميرا المحلول
//   • copyWith() — نسخ الحالة مع تعديلات
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:equatable/equatable.dart';

import '../../domain/robot_camera_urls.dart';
import '../../domain/entities/robot_live_status.dart';

/// حالة شاشة التحكم بالروبوت (مضخة، GPS، كاميرا، اتصال Firestore).
class RobotControlState extends Equatable {
  /// دالة الروبوت التحكم الحالة.
  const RobotControlState({
    this.waterPumpOn = false,
    this.autoModeOn = false,
    this.isLoading = false,
    this.isFirestoreConnected = false,
    this.status = const RobotLiveStatus(),
    this.gpsLabel = _defaultGps,
    this.errorMessage,
  });

  /// إحداثيات GPS الافتراضية عند غياب البيانات.
  static const _defaultGps = '31.95° N, 35.93° E';

  /// هل مضخة المياه مفعّلة في الواجهة؟
  final bool waterPumpOn;

  /// هل الوضع التلقائي مفعّل في الواجهة؟
  final bool autoModeOn;

  /// هل يُرسل أمر حالياً إلى Firestore؟
  final bool isLoading;

  /// هل الاتصال بـ Firestore نشط؟
  final bool isFirestoreConnected;

  /// آخر لقطة حالة من robot_status.
  final RobotLiveStatus status;

  /// نص GPS المعروض في الشريط العلوي.
  final String gpsLabel;

  /// رسالة خطأ تُعرض في SnackBar.
  final String? errorMessage;

  /// هل الروبوت متصل (من حقل online)؟
  bool get robotOnline => status.online;

  /// رابط بث الكاميرا: من Firestore أو العنوان الاحتياطي.
  String get cameraStreamUrl =>
      RobotCameraUrls.resolve(status.cameraUrl);

  /// ينسخ الكائن مع تعديل بعض الحقول.
  RobotControlState copyWith({
    bool? waterPumpOn,
    bool? autoModeOn,
    bool? isLoading,
    bool? isFirestoreConnected,
    RobotLiveStatus? status,
    String? gpsLabel,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RobotControlState(
      waterPumpOn: waterPumpOn ?? this.waterPumpOn,
      autoModeOn: autoModeOn ?? this.autoModeOn,
      isLoading: isLoading ?? this.isLoading,
      isFirestoreConnected: isFirestoreConnected ?? this.isFirestoreConnected,
      status: status ?? this.status,
      gpsLabel: gpsLabel ?? this.gpsLabel,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  /// يُرجع props.
  List<Object?> get props => [
        waterPumpOn,
        autoModeOn,
        isLoading,
        isFirestoreConnected,
        status,
        gpsLabel,
        errorMessage,
      ];
}
