import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:match_and_watch/core/database/app_database.dart';
import 'package:match_and_watch/core/network/tmdb_service.dart';
import 'package:match_and_watch/core/repositories/movie_repository.dart';

class MockAppDatabase extends Mock implements AppDatabase {}
class MockTmdbService extends Mock implements TmdbService {}

void main() {
  late MovieRepository repository;
  late MockAppDatabase mockDb;
  late MockTmdbService mockTmdbService;

  setUp(() {
    mockDb = MockAppDatabase();
    mockTmdbService = MockTmdbService();
    repository = MovieRepository(mockDb, mockTmdbService);
  });

  group('MovieRepository', () {
    test('refreshMovies should rethrow on API error (simulating offline/failure)', () async {
      when(() => mockTmdbService.getTrendingMovies(page: any(named: 'page'), silent: any(named: 'silent')))
          .thenThrow(Exception('Network Error'));

      expect(() => repository.refreshMovies(page: 1), throwsException);
    });

    test('watchUsersWhoSavedMovie should return stream from database', () {
      final users = [
        const User(id: 1, firstName: 'A', lastName: 'B', movieTaste: 'T', pendingSync: false),
      ];
      when(() => mockDb.watchUsersWhoSavedMovie(1)).thenAnswer((_) => Stream.value(users));

      final result = repository.watchUsersWhoSavedMovie(1);

      expect(result, emits(users));
    });
  });
}
