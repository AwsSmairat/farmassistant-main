import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_it/get_it.dart';

import '../../features/ai_plant_diagnosis/data/datasources/ai_diagnosis_callable_datasource.dart';
import '../../features/ai_plant_diagnosis/data/datasources/ai_diagnosis_remote_datasource.dart';
import '../../features/ai_plant_diagnosis/data/datasources/plant_image_upload_datasource.dart';
import '../../features/ai_plant_diagnosis/data/repositories/ai_diagnosis_record_repository_impl.dart';
import '../../features/ai_plant_diagnosis/data/services/firebase_ai_diagnosis_service.dart';
import '../../features/ai_plant_diagnosis/data/services/mock_ai_diagnosis_service.dart';
import '../../features/ai_plant_diagnosis/data/services/resilient_ai_diagnosis_service.dart';
import '../../features/ai_plant_diagnosis/domain/repositories/ai_diagnosis_record_repository.dart';
import '../../features/ai_plant_diagnosis/domain/services/ai_diagnosis_service.dart';
import '../../features/ai_plant_diagnosis/domain/usecases/analyze_plant_image.dart';
import '../../features/ai_plant_diagnosis/domain/usecases/save_ai_diagnosis_record.dart';
import '../../features/ai_plant_diagnosis/presentation/cubit/ai_plant_diagnosis_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/user_profile_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/user_profile_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/user_profile_repository.dart';
import '../../features/auth/domain/usecases/create_account_with_email.dart';
import '../../features/auth/domain/usecases/send_password_reset.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_in_with_identifier.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/stream_auth_state.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';
import '../../features/diagnosis/data/repositories/diagnosis_repository_impl.dart';
import '../../features/diagnosis/domain/repositories/diagnosis_repository.dart';
import '../../features/diagnosis/domain/usecases/watch_diagnosis_history.dart';
import '../../features/diagnosis/presentation/cubit/diagnosis_history_cubit.dart';
import '../../features/home/data/repositories/dashboard_repository_impl.dart';
import '../../features/home/domain/repositories/dashboard_repository.dart';
import '../../features/home/domain/usecases/watch_dashboard_data.dart';
import '../../features/home/presentation/cubit/dashboard_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource_impl.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/clear_all_notifications.dart';
import '../../features/notifications/domain/usecases/delete_notification.dart';
import '../../features/notifications/domain/usecases/mark_notification_read.dart';
import '../../features/notifications/domain/usecases/watch_notifications.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/get_privacy_policy.dart';
import '../../features/profile/domain/usecases/save_privacy_policy.dart';
import '../../features/profile/domain/usecases/update_profile.dart';
import '../../features/profile/data/datasources/privacy_policy_remote_datasource.dart';
import '../../features/profile/data/repositories/privacy_policy_repository_impl.dart';
import '../../features/profile/domain/repositories/privacy_policy_repository.dart';
import '../../features/profile/presentation/cubit/privacy_policy_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/robot/data/services/robot_command_service.dart';
import '../../features/robot/domain/usecases/dispatch_robot_firestore_commands.dart';
import '../../features/robot/presentation/cubit/robot_control_cubit.dart';
import '../../features/sensors/data/datasources/sensors_remote_datasource.dart';
import '../../features/sensors/data/datasources/sensors_remote_datasource_impl.dart';
import '../../features/sensors/data/repositories/sensors_repository_impl.dart';
import '../../features/sensors/domain/repositories/sensors_repository.dart';
import '../../features/sensors/domain/usecases/watch_sensors_dashboard.dart';
import '../../features/sensors/presentation/cubit/sensors_cubit.dart';
import '../../features/telemetry/data/datasources/farm_firestore_telemetry_datasource.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(),
  );
  getIt.registerLazySingleton<UserProfileRemoteDatasource>(
    () => UserProfileRemoteDatasource(),
  );
  getIt.registerLazySingleton<FarmFirestoreTelemetryDatasource>(
    () => FarmFirestoreTelemetryDatasource(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDatasource>()),
  );
  getIt.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(getIt<UserProfileRemoteDatasource>()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SignInWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => SignInWithIdentifier(
      getIt<AuthRepository>(),
      getIt<UserProfileRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => CreateAccountWithEmail(
      getIt<AuthRepository>(),
      getIt<UserProfileRepository>(),
    ),
  );
  getIt.registerLazySingleton(() => SendPasswordReset(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithGoogle(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOut(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => StreamAuthState(getIt<AuthRepository>()));

  // Cubits (factory: new instance per route)
  getIt.registerFactory<LoginCubit>(() {
    return LoginCubit(
      signInWithIdentifier: getIt<SignInWithIdentifier>(),
      signInWithGoogle: getIt<SignInWithGoogle>(),
      userProfileRepository: getIt<UserProfileRepository>(),
      signOut: getIt<SignOut>(),
    );
  });
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(
      createAccountWithEmail: getIt<CreateAccountWithEmail>(),
      signInWithGoogle: getIt<SignInWithGoogle>(),
      userProfileRepository: getIt<UserProfileRepository>(),
      signOut: getIt<SignOut>(),
    ),
  );
  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(getIt<SendPasswordReset>()),
  );

  // الروبوت: خدمة Firestore + حالة استخدام الأوامر + Cubit شاشة التحكم.
  getIt.registerLazySingleton<RobotCommandService>(() => RobotCommandService());
  getIt.registerLazySingleton(
    () => DispatchRobotFirestoreCommands(getIt<RobotCommandService>()),
  );
  getIt.registerFactory<RobotControlCubit>(
    () => RobotControlCubit(getIt<RobotCommandService>())..start(),
  );

  // Home / Dashboard (Firestore realtime)
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      getIt<AuthRepository>(),
      getIt<UserProfileRepository>(),
      getIt<FarmFirestoreTelemetryDatasource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => WatchDashboardData(getIt<DashboardRepository>()),
  );
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt<WatchDashboardData>()),
  );

  // Notifications
  getIt.registerLazySingleton<NotificationsRemoteDatasource>(
    () => NotificationsRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt<NotificationsRemoteDatasource>()),
  );
  getIt.registerLazySingleton(
    () => WatchNotifications(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkNotificationRead(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteNotification(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => ClearAllNotifications(getIt<NotificationsRepository>()),
  );
  getIt.registerFactory(
    () => NotificationsCubit(
      getIt<WatchNotifications>(),
      getIt<MarkNotificationRead>(),
      getIt<DeleteNotification>(),
      getIt<ClearAllNotifications>(),
    ),
  );

  // Profile
  getIt.registerLazySingleton(
    () => GetProfile(getIt<AuthRepository>(), getIt<UserProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () =>
        UpdateProfile(getIt<AuthRepository>(), getIt<UserProfileRepository>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<GetProfile>(), getIt<UpdateProfile>()),
  );

  // Privacy policy
  getIt.registerLazySingleton<PrivacyPolicyRemoteDatasource>(
    () => PrivacyPolicyRemoteDatasource(),
  );
  getIt.registerLazySingleton<PrivacyPolicyRepository>(
    () => PrivacyPolicyRepositoryImpl(getIt<PrivacyPolicyRemoteDatasource>()),
  );
  getIt.registerLazySingleton(
    () => GetPrivacyPolicy(getIt<PrivacyPolicyRepository>()),
  );
  getIt.registerLazySingleton(
    () => SavePrivacyPolicy(getIt<PrivacyPolicyRepository>()),
  );
  getIt.registerFactory<PrivacyPolicyCubit>(
    () => PrivacyPolicyCubit(
      getIt<GetPrivacyPolicy>(),
      getIt<SavePrivacyPolicy>(),
    ),
  );

  // Sensors dashboard (Firestore realtime)
  getIt.registerLazySingleton<SensorsRemoteDatasource>(
    () =>
        SensorsRemoteDatasourceImpl(getIt<FarmFirestoreTelemetryDatasource>()),
  );
  getIt.registerLazySingleton<SensorsRepository>(
    () => SensorsRepositoryImpl(getIt<SensorsRemoteDatasource>()),
  );
  getIt.registerLazySingleton(
    () => WatchSensorsDashboard(getIt<SensorsRepository>()),
  );
  getIt.registerFactory<SensorsCubit>(
    () => SensorsCubit(getIt<WatchSensorsDashboard>()),
  );

  // Diagnosis history (Firestore realtime)
  getIt.registerLazySingleton<DiagnosisRepository>(
    () => DiagnosisRepositoryImpl(getIt<FarmFirestoreTelemetryDatasource>()),
  );
  getIt.registerLazySingleton(
    () => WatchDiagnosisHistory(getIt<DiagnosisRepository>()),
  );
  getIt.registerFactory<DiagnosisHistoryCubit>(
    () => DiagnosisHistoryCubit(getIt<WatchDiagnosisHistory>()),
  );

  // AI plant diagnosis: Storage + callable (Cloud Function + external AI), mock fallback
  // Callable region: default us-central1. If the function is deployed elsewhere, build with:
  // --dart-define=FIREBASE_FUNCTIONS_REGION=europe-west1 (example).
  getIt.registerLazySingleton<PlantImageUploadDatasource>(
    () => PlantImageUploadDatasource(),
  );
  getIt.registerLazySingleton<AiDiagnosisCallableDatasource>(
    () => AiDiagnosisCallableDatasource(
      functions: FirebaseFunctions.instanceFor(
        region: const String.fromEnvironment(
          'FIREBASE_FUNCTIONS_REGION',
          defaultValue: 'us-central1',
        ),
      ),
    ),
  );
  getIt.registerLazySingleton<AiDiagnosisRemoteDatasource>(
    () => AiDiagnosisRemoteDatasource(
      imageUpload: getIt<PlantImageUploadDatasource>(),
    ),
  );
  getIt.registerLazySingleton<AiDiagnosisRecordRepository>(
    () => AiDiagnosisRecordRepositoryImpl(getIt<AiDiagnosisRemoteDatasource>()),
  );
  getIt.registerLazySingleton<MockAiDiagnosisService>(() => MockAiDiagnosisService());
  getIt.registerLazySingleton<FirebaseAiDiagnosisService>(
    () => FirebaseAiDiagnosisService(
      imageUpload: getIt<PlantImageUploadDatasource>(),
      callable: getIt<AiDiagnosisCallableDatasource>(),
    ),
  );
  getIt.registerLazySingleton<AiDiagnosisService>(
    () => ResilientAiDiagnosisService(
      firebase: getIt<FirebaseAiDiagnosisService>(),
      mock: getIt<MockAiDiagnosisService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => AnalyzePlantImage(getIt<AiDiagnosisService>()),
  );
  getIt.registerLazySingleton(
    () => SaveAiDiagnosisRecord(getIt<AiDiagnosisRecordRepository>()),
  );
  getIt.registerFactory<AiPlantDiagnosisCubit>(
    () => AiPlantDiagnosisCubit(
      analyzePlantImage: getIt<AnalyzePlantImage>(),
      saveAiDiagnosisRecord: getIt<SaveAiDiagnosisRecord>(),
    ),
  );
}
