import 'package:get_it/get_it.dart';

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
import '../../features/home/data/datasources/robot_sensor_remote_datasource.dart';
import '../../features/home/data/datasources/robot_sensor_remote_datasource_impl.dart';
import '../../features/home/data/repositories/dashboard_repository_impl.dart';
import '../../features/home/domain/repositories/dashboard_repository.dart';
import '../../features/home/domain/usecases/get_dashboard_data.dart';
import '../../features/home/presentation/cubit/dashboard_cubit.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/update_profile.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasource());
  getIt.registerLazySingleton<UserProfileRemoteDatasource>(
    () => UserProfileRemoteDatasource(),
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
  getIt.registerLazySingleton(() => SignInWithIdentifier(
        getIt<AuthRepository>(),
        getIt<UserProfileRepository>(),
      ));
  getIt.registerLazySingleton(() => CreateAccountWithEmail(
        getIt<AuthRepository>(),
        getIt<UserProfileRepository>(),
      ));
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
    ),
  );
  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(getIt<SendPasswordReset>()),
  );

  // Home / Dashboard
  getIt.registerLazySingleton<RobotSensorRemoteDatasource>(
    () => RobotSensorRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      getIt<AuthRepository>(),
      getIt<UserProfileRepository>(),
      getIt<RobotSensorRemoteDatasource>(),
    ),
  );
  getIt.registerLazySingleton(() => GetDashboardData(getIt<DashboardRepository>()));
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt<GetDashboardData>()),
  );

  // Profile
  getIt.registerLazySingleton(() => GetProfile(
        getIt<AuthRepository>(),
        getIt<UserProfileRepository>(),
      ));
  getIt.registerLazySingleton(() => UpdateProfile(
        getIt<AuthRepository>(),
        getIt<UserProfileRepository>(),
      ));
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<GetProfile>(), getIt<UpdateProfile>()),
  );
}
