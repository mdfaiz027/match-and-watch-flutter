import 'package:flutter_test/flutter_test.dart';
import 'package:match_and_watch/main.dart';
import 'package:match_and_watch/core/database/app_database.dart';
import 'package:match_and_watch/core/network/api_client.dart';
import 'package:match_and_watch/core/network/reqres_service.dart';
import 'package:match_and_watch/core/network/tmdb_service.dart';
import 'package:match_and_watch/core/repositories/user_repository.dart';
import 'package:match_and_watch/core/repositories/movie_repository.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Use an in-memory database for testing
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final apiClient = ApiClient();
    final reqresService = ReqresService(apiClient);
    final tmdbService = TmdbService(apiClient);
    final userRepository = UserRepository(database, reqresService);
    final movieRepository = MovieRepository(database, tmdbService);

    await tester.pumpWidget(MatchAndWatchApp(
      userRepository: userRepository,
      movieRepository: movieRepository,
    ));

    // The initial route is UsersPage, which has this title
    expect(find.text('Match & Watch Users'), findsOneWidget);
    
    await database.close();
  });
}
