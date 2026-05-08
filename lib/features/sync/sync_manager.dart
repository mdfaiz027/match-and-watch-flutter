import 'dart:developer' as developer;
import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../core/network/api_client.dart';
import '../../core/network/reqres_service.dart';

const String syncTaskName = "com.match_and_watch.syncUsersTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final database = AppDatabase();
    final apiClient = ApiClient();
    final reqresService = ReqresService(apiClient);

    try {
      // 1. Query users needing sync
      final pendingUsers = await (database.select(database.users)
            ..where((u) => u.pendingSync.equals(true)))
          .get();

      for (final user in pendingUsers) {
        try {
          // 2. Attempt to POST to API
          final response = await reqresService.createUser(
            firstName: user.firstName,
            lastName: user.lastName,
            movieTaste: user.movieTaste,
          );

          if (response.statusCode == 201 || response.statusCode == 200) {
            final serverId = int.tryParse(response.data['id'].toString());
            
            // 3. Update local database
            await (database.update(database.users)
                  ..where((u) => u.id.equals(user.id)))
                .write(UsersCompanion(
              serverId: Value(serverId),
              pendingSync: const Value(false),
            ));
          }
        } catch (e) {
          // Individual user sync failed, continue to next but don't mark task as success if needed
          developer.log("Failed to sync user ${user.id}: $e");
        }
      }
      return Future.value(true);
    } catch (e) {
      developer.log("Sync task error: $e");
      return Future.value(false);
    } finally {
      await database.close();
    }
  });
}
