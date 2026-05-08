import 'dart:developer' as developer;
import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../core/network/reqres_service.dart';
import '../../core/di/injection_container.dart' as di;

const String syncTaskName = "com.match_and_watch.syncUsersTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Ensure DI is initialized in the background isolate
    await di.init();
    
    final database = di.sl<AppDatabase>();
    final reqresService = di.sl<ReqresService>();

    try {
      // 1. Query users needing sync
      final pendingUsers = await (database.select(database.users)
            ..where((u) => u.pendingSync.equals(true)))
          .get();

      for (final user in pendingUsers) {
        try {
          // 2. Attempt to POST to API
          final fullName = '${user.firstName} ${user.lastName}'.trim();
          final response = await reqresService.createUser(
            fullName: fullName,
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
      // 4. Notify about results if any users were synced
      if (pendingUsers.isNotEmpty) {
        // Since we are in a background isolate, we can't show a SnackBar directly here.
        // The UI will update automatically via the stream from the database.
        developer.log("Sync task completed for ${pendingUsers.length} users.");
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
