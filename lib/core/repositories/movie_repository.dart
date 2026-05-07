import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../network/tmdb_service.dart';

class MovieRepository {
  final AppDatabase _db;
  final TmdbService _tmdbService;

  MovieRepository(this._db, this._tmdbService);

  Stream<List<Movie>> watchTrendingMovies() {
    return _db.select(_db.movies).watch();
  }

  Future<void> refreshTrendingMovies({int page = 1}) async {
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
      // Fail silently to rely on local data
    }
  }

  Future<void> toggleSaveMovie(int userId, Movie movie) async {
    final query = _db.delete(_db.savedMovies)
      ..where((t) => t.userId.equals(userId) & t.movieId.equals(movie.id));
    
    final deletedCount = await query.go();

    if (deletedCount == 0) {
      // Ensure movie exists in local DB before saving relation
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
}
