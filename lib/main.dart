import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'core/theme/app_theme.dart';
import 'features/sync/sync_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/users/bloc/user_cubit.dart';
import 'features/users/bloc/active_user_cubit.dart';
import 'features/movies/bloc/movie_cubit.dart';
import 'features/onboarding/bloc/onboarding_cubit.dart';
import 'core/router/app_router.dart';
import 'core/network/connection_state.dart';
import 'core/di/injection_container.dart' as di;
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await di.init();

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

  runApp(const MatchAndWatchApp());
}

class MatchAndWatchApp extends StatelessWidget {
  const MatchAndWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ActiveUserCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<MovieCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<OnboardingCubit>(),
        ),
      ],
      child: ShowCaseWidget(
        blurValue: 3.0,
        onStart: (index, key) => HapticFeedback.lightImpact(),
        onComplete: (index, key) => HapticFeedback.lightImpact(),
        builder: (context) => MaterialApp.router(
          title: 'Match & Watch',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: appRouter,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            return Stack(
              children: [
                child,
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
                          color: Colors.orange.withValues(alpha: 0.9),
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
      ),
    );
  }
}
