import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../network/tmdb_service.dart';

class MovieRepository {
  final AppDatabase _db;
  final TmdbService _tmdbService;

  MovieRepository(this._db, this._tmdbService);

  Stream<List<Movie>> watchMovies() {
    return _db.select(_db.movies).watch();
  }

  Future<void> refreshMovies({int page = 1}) async {
    try {
      final response = await _tmdbService.getTrendingMovies(page: page);
      final moviesData = response.data['results'] as List;

      final companions = moviesData.map((m) {
        return MoviesCompanion.insert(
          id: Value(m['id']),
          title: m['title'] ?? m['name'] ?? 'Untitled',
          posterPath: Value(m['poster_path']),
          releaseYear: Value(m['release_date']?.toString().split('-').first),
          overview: Value(m['overview']),
        );
      }).toList();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(_db.movies, companions);
      });
    } catch (e) {
      // Fail silently
    }
  }

  Future<void> fetchMovieDetails(int movieId) async {
    try {
      final response = await _tmdbService.getMovieDetails(movieId);
      final m = response.data;
      
      await _db.into(_db.movies).insertOnConflictUpdate(
        MoviesCompanion.insert(
          id: Value(movieId),
          title: m['title'] ?? 'Untitled',
          posterPath: Value(m['poster_path']),
          releaseYear: Value(m['release_date']?.toString().split('-').first),
          overview: Value(m['overview']),
        ),
      );
    } catch (e) {
      // Fail silently
    }
  }

  Stream<Movie?> watchMovieById(int id) {
    return (_db.select(_db.movies)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<void> toggleSaveMovie(int userId, Movie movie) async {
    final query = _db.delete(_db.savedMovies)
      ..where((t) => t.userId.equals(userId) & t.movieId.equals(movie.id));
    
    final deletedCount = await query.go();

    if (deletedCount == 0) {
      await _db.into(_db.movies).insertOnConflictUpdate(movie);
      
      await _db.into(_db.savedMovies).insert(
            SavedMoviesCompanion.insert(
              userId: userId,
              movieId: movie.id,
              createdAt: DateTime.now(),
            ),
          );
    }
  }

  Stream<List<Movie>> watchSavedMovies(int userId) {
    final query = _db.select(_db.movies).join([
      innerJoin(_db.savedMovies, _db.savedMovies.movieId.equalsExp(_db.movies.id)),
    ])
      ..where(_db.savedMovies.userId.equals(userId));

    return query.watch().map((rows) => rows.map((row) => row.readTable(_db.movies)).toList());
  }

  Stream<List<User>> watchUsersWhoSavedMovie(int movieId) {
    final query = _db.select(_db.users).join([
      innerJoin(_db.savedMovies, _db.savedMovies.userId.equalsExp(_db.users.id)),
    ])
      ..where(_db.savedMovies.movieId.equals(movieId));

    return query.watch().map((rows) => rows.map((row) => row.readTable(_db.users)).toList());
  }

  Stream<int> watchSaveCountForMovie(int movieId) {
    final countExp = _db.savedMovies.userId.count();
    final query = _db.selectOnly(_db.savedMovies)
      ..addColumns([countExp])
      ..where(_db.savedMovies.movieId.equals(movieId));

    return query.watchSingle().map((row) => row.read(countExp) ?? 0);
  }

  Stream<List<({Movie movie, List<User> users})>> watchMatches() {
    final movieStream = _db.select(_db.movies).watch();
    
    return movieStream.asyncMap((movies) async {
      final matches = <({Movie movie, List<User> users})>[];
      
      for (final movie in movies) {
        final users = await (_db.select(_db.users).join([
          innerJoin(_db.savedMovies, _db.savedMovies.userId.equalsExp(_db.users.id)),
        ])..where(_db.savedMovies.movieId.equals(movie.id))).get().then(
          (rows) => rows.map((row) => row.readTable(_db.users)).toList(),
        );
        
        if (users.length >= 2) {
          matches.add((movie: movie, users: users));
        }
      }
      
      matches.sort((a, b) => b.users.length.compareTo(a.users.length));
      return matches;
    });
  }

  Stream<int> watchTotalUserCount() {
    final countExp = _db.users.id.count();
    final query = _db.selectOnly(_db.users)..addColumns([countExp]);
    return query.watchSingle().map((row) => row.read(countExp) ?? 0);
  }

  Stream<bool> watchIsSaved(int userId, int movieId) {
    final query = _db.select(_db.savedMovies)
      ..where((t) => t.userId.equals(userId) & t.movieId.equals(movieId));
    return query.watch().map((list) => list.isNotEmpty);
  }
}
