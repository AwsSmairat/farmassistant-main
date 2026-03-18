import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/create_account_with_email.dart';
import '../../features/auth/domain/usecases/send_password_reset.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/stream_auth_state.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasource());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDatasource>()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SignInWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CreateAccountWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SendPasswordReset(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithGoogle(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOut(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => StreamAuthState(getIt<AuthRepository>()));

  // Cubits (factory: new instance per route)
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      signInWithEmail: getIt<SignInWithEmail>(),
      signInWithGoogle: getIt<SignInWithGoogle>(),
    ),
  );
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(
      createAccountWithEmail: getIt<CreateAccountWithEmail>(),
      signInWithGoogle: getIt<SignInWithGoogle>(),
    ),
  );
  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(getIt<SendPasswordReset>()),
  );
}
