import 'package:go_router/go_router.dart';
import '../../features/users/presentation/users_page.dart';
import '../../features/users/presentation/add_user_page.dart';

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
  ],
);
