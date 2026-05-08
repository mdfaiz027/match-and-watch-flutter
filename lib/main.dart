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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/users/bloc/user_cubit.dart';
import 'features/users/bloc/active_user_cubit.dart';
import 'features/movies/bloc/movie_cubit.dart';
import 'core/router/app_router.dart';
import 'core/network/connection_state.dart';

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
  await Workmanager().initialize(callbackDispatcher);

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(userRepository),
        ),
        BlocProvider(
          create: (context) => ActiveUserCubit(),
        ),
        BlocProvider(
          create: (context) => MovieCubit(movieRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'Match & Watch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: appRouter,
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              ValueListenableBuilder<bool>(
                valueListenable: connectionNotifier,
                builder: (context, isReconnecting, _) {
                  if (!isReconnecting) return const SizedBox.shrink();
                  return Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        color: Colors.orange.withOpacity(0.9),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        child: const Text(
                          'Reconnecting...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
