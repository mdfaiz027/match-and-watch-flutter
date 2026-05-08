import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get avatar => text().nullable()();
  TextColumn get movieTaste => text()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(false))();
}

@DataClassName('Movie')
class Movies extends Table {
  IntColumn get id => integer()(); // TMDB/OMDB ID
  TextColumn get title => text()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get releaseYear => text().nullable()();
  TextColumn get overview => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SavedMovies extends Table {
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get movieId => integer().references(Movies, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, movieId};
}

@DriftDatabase(tables: [Users, Movies, SavedMovies])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  Stream<List<User>> watchUsersWhoSavedMovie(int movieId) {
    final query = select(users).join([
      innerJoin(savedMovies, savedMovies.userId.equalsExp(users.id)),
    ])
      ..where(savedMovies.movieId.equals(movieId));

    return query.watch().map((rows) => rows.map((row) => row.readTable(users)).toList());
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
