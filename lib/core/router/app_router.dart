import 'package:go_router/go_router.dart';
import '../../features/users/presentation/users_page.dart';
import '../../features/users/presentation/add_user_page.dart';
import '../../features/movies/presentation/movies_page.dart';
import '../../features/movies/presentation/movie_detail_page.dart';

import '../../features/users/presentation/saved_movies_page.dart';
import '../../features/movies/presentation/matches_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'users',
      builder: (context, state) => const UsersPage(),
    ),
    GoRoute(
      path: '/add_user',
      name: 'add_user',
      builder: (context, state) => const AddUserPage(),
    ),
    GoRoute(
      path: '/movies',
      name: 'movies',
      builder: (context, state) => const MoviesPage(),
    ),
    GoRoute(
      path: '/movie/:id',
      name: 'movie_detail',
      builder: (context, state) {
        final movieId = int.parse(state.pathParameters['id']!);
        return MovieDetailPage(movieId: movieId);
      },
    ),
    GoRoute(
      path: '/saved_movies',
      name: 'saved_movies',
      builder: (context, state) {
        final profileUserId = int.tryParse(state.uri.queryParameters['profileUserId'] ?? '');
        return SavedMoviesPage(profileUserId: profileUserId);
      },
    ),
    GoRoute(
      path: '/matches',
      name: 'matches',
      builder: (context, state) => const MatchesPage(),
    ),
  ],
);
