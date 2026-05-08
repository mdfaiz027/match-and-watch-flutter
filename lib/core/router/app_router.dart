import 'package:go_router/go_router.dart';
import '../../features/users/presentation/users_page.dart';
import '../../features/users/presentation/add_user_page.dart';
import '../../features/movies/presentation/movies_page.dart';
import '../../features/movies/presentation/movie_detail_page.dart';

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
      builder: (context, state) {
        final userId = int.parse(state.uri.queryParameters['userId'] ?? '0');
        return MoviesPage(userId: userId);
      },
    ),
    GoRoute(
      path: '/movie/:id',
      name: 'movie_detail',
      builder: (context, state) {
        final movieId = int.parse(state.pathParameters['id']!);
        final userId = int.parse(state.uri.queryParameters['userId'] ?? '0');
        return MovieDetailPage(movieId: movieId, userId: userId);
      },
    ),
  ],
);
