import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../network/reqres_service.dart';
import '../network/tmdb_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/movie_repository.dart';
import '../../features/users/bloc/user_cubit.dart';
import '../../features/users/bloc/active_user_cubit.dart';
import '../../features/movies/bloc/movie_cubit.dart';
import '../../features/onboarding/bloc/onboarding_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<Dio>(() => sl<ApiClient>().dio);

  // Services
  sl.registerLazySingleton<ReqresService>(() => ReqresService(sl()));
  sl.registerLazySingleton<TmdbService>(() => TmdbService(sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl(), sl()));
  sl.registerLazySingleton<MovieRepository>(() => MovieRepository(sl(), sl()));

  // State Management (Cubit)
  sl.registerFactory(() => UserCubit(sl()));
  sl.registerLazySingleton(() => ActiveUserCubit());
  sl.registerFactory(() => MovieCubit(sl()));
  sl.registerFactory(() => OnboardingCubit(sl()));
}
