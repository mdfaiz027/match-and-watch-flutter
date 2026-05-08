import 'package:flutter_test/flutter_test.dart';
import 'package:match_and_watch/main.dart';
import 'package:match_and_watch/core/database/app_database.dart';
import 'package:match_and_watch/core/network/api_client.dart';
import 'package:match_and_watch/core/network/reqres_service.dart';
import 'package:match_and_watch/core/network/tmdb_service.dart';
import 'package:match_and_watch/core/repositories/user_repository.dart';
import 'package:match_and_watch/core/repositories/movie_repository.dart';
import 'package:match_and_watch/features/users/bloc/user_cubit.dart';
import 'package:match_and_watch/features/users/bloc/active_user_cubit.dart';
import 'package:match_and_watch/features/movies/bloc/movie_cubit.dart';
import 'package:match_and_watch/core/di/injection_container.dart';
import 'package:drift/native.dart';
import 'package:dio/dio.dart';

void main() {
  setUp(() async {
    await sl.reset();
  });

  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Use an in-memory database for testing
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final apiClient = ApiClient();
    
    sl.registerSingleton<AppDatabase>(database);
    sl.registerSingleton<ApiClient>(apiClient);
    sl.registerSingleton<Dio>(apiClient.dio);
    sl.registerSingleton<ReqresService>(ReqresService(sl()));
    sl.registerSingleton<TmdbService>(TmdbService(sl()));
    sl.registerSingleton<UserRepository>(UserRepository(sl(), sl()));
    sl.registerSingleton<MovieRepository>(MovieRepository(sl(), sl()));
    sl.registerFactory(() => UserCubit(sl()));
    sl.registerSingleton(ActiveUserCubit());
    sl.registerFactory(() => MovieCubit(sl()));

    await tester.pumpWidget(const MatchAndWatchApp());

    // The initial route is UsersPage, which has this title
    expect(find.text('Match & Watch Users'), findsOneWidget);
    
    await database.close();
  });
}
