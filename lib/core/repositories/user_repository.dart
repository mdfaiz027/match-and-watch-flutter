import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../network/reqres_service.dart';

class UserRepository {
  final AppDatabase _db;
  final ReqresService _reqresService;

  UserRepository(this._db, this._reqresService);

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
      // Offline or network error: we just fail silently as the stream 
      // will still provide existing local data.
    }
  }

  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String movieTaste,
  }) async {
    bool pendingSync = false;
    int? serverId;

    try {
      final response = await _reqresService.createUser(
        firstName: firstName,
        lastName: lastName,
        movieTaste: movieTaste,
      );
      serverId = int.tryParse(response.data['id'].toString());
    } catch (e) {
      pendingSync = true;
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
}
