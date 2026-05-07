import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'core/database/app_database.dart';
import 'core/network/api_client.dart';
import 'core/network/reqres_service.dart';
import 'core/network/tmdb_service.dart';
import 'core/repositories/user_repository.dart';
import 'core/repositories/movie_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/sync/sync_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core components
  final database = AppDatabase();
  final apiClient = ApiClient();
  
  // Services
  final reqresService = ReqresService(apiClient);
  final tmdbService = TmdbService(apiClient);

  // Repositories
  final userRepository = UserRepository(database, reqresService);
  final movieRepository = MovieRepository(database, tmdbService);

  // Initialize WorkManager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );

  // Register the sync task
  await Workmanager().registerPeriodicTask(
    "1",
    syncTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(MatchAndWatchApp(
    userRepository: userRepository,
    movieRepository: movieRepository,
  ));
}

class MatchAndWatchApp extends StatelessWidget {
  final UserRepository userRepository;
  final MovieRepository movieRepository;

  const MatchAndWatchApp({
    super.key,
    required this.userRepository,
    required this.movieRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match & Watch',
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Match & Watch Initialized'),
        ),
      ),
    );
  }
}
