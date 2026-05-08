import 'package:drift/drift.dart';
import 'package:dio/dio.dart';
import '../database/app_database.dart';
import '../network/reqres_service.dart';

class UserWithMovieCount {
  final User user;
  final int movieCount;
  UserWithMovieCount(this.user, this.movieCount);
}

class UserRepository {
  final AppDatabase _db;
  final ReqresService _reqresService;

  UserRepository(this._db, this._reqresService);

  Stream<List<UserWithMovieCount>> watchUsersWithMovieCount() {
    final countExp = _db.savedMovies.userId.count();
    final query = _db.select(_db.users).join([
      leftOuterJoin(_db.savedMovies, _db.savedMovies.userId.equalsExp(_db.users.id)),
    ])
      ..addColumns([countExp])
      ..groupBy([_db.users.id]);

    return query.watch().map((rows) {
      return rows.map<UserWithMovieCount>((row) {
        return UserWithMovieCount(
          row.readTable(_db.users),
          row.read(countExp) ?? 0,
        );
      }).toList();
    });
  }

  Stream<List<User>> watchUsers() {
    return _db.select(_db.users).watch();
  }

  Future<void> refreshUsers({int page = 1}) async {
    try {
      final response = await _reqresService.getUsers(page: page);
      final usersData = response.data['data'] as List;

      final companions = usersData.map((u) {
        return UsersCompanion.insert(
          serverId: Value(u['id']),
          firstName: u['first_name'],
          lastName: u['last_name'],
          avatar: Value(u['avatar']),
          movieTaste: 'Unknown', // Reqres doesn't provide this by default
          pendingSync: const Value(false),
        );
      }).toList();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(_db.users, companions);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser({
    required String fullName,
    required String movieTaste,
  }) async {
    // Safely split name
    final parts = fullName.trim().split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    bool pendingSync = false;
    int? serverId;

    try {
      final response = await _reqresService.createUser(
        fullName: fullName,
        movieTaste: movieTaste,
      );
      serverId = int.tryParse(response.data['id'].toString());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        pendingSync = true;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }

    await _db.into(_db.users).insert(
          UsersCompanion.insert(
            serverId: Value(serverId),
            firstName: firstName,
            lastName: lastName,
            movieTaste: movieTaste,
            pendingSync: Value(pendingSync),
          ),
        );
  }

  Stream<int> watchSavedMovieCount(int userId) {
    final countExp = _db.savedMovies.movieId.count();
    final query = _db.selectOnly(_db.savedMovies)
      ..addColumns([countExp])
      ..where(_db.savedMovies.userId.equals(userId));

    return query.watchSingle().map((row) => row.read(countExp) ?? 0);
  }

  Stream<User?> watchUserById(int userId) {
    return (_db.select(_db.users)..where((t) => t.id.equals(userId))).watchSingleOrNull();
  }
}
