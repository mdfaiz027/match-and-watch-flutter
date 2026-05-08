import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/user_cubit.dart';
import '../bloc/active_user_cubit.dart';
import '../../movies/bloc/movie_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';

class SavedMoviesPage extends StatelessWidget {
  const SavedMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveUserCubit, User?>(
      builder: (context, activeUser) {
        if (activeUser == null) {
          return const Scaffold(
            body: Center(child: Text('No active user selected.')),
          );
        }

        final userId = activeUser.id;
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Saved Movies'),
          ),
          body: StreamBuilder<User?>(
            stream: context.read<UserCubit>().watchUserById(userId),
            builder: (context, userSnapshot) {
              final user = userSnapshot.data;
              if (user == null) return const Center(child: CircularProgressIndicator());

              return Column(
                children: [
                  _buildHeader(context, user),
                  Expanded(child: _buildSavedList(context, userId)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.surfaceGrey,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user.avatar != null ? CachedNetworkImageProvider(user.avatar!) : null,
            child: user.avatar == null ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Taste: ${user.movieTaste}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.cinematicGold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedList(BuildContext context, int userId) {
    return StreamBuilder<List<Movie>>(
      stream: context.read<MovieCubit>().watchSavedMovies(userId),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        if (movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie_filter, size: 80, color: Colors.white24),
                const SizedBox(height: 16),
                Text(
                  'No saved movies yet.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white54),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start browsing and save some!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: movie.posterPath != null
                        ? 'https://image.tmdb.org/t/p/w185${movie.posterPath}'
                        : '',
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(movie.title, style: Theme.of(context).textTheme.titleLarge),
                trailing: IconButton(
                  icon: const Icon(Icons.bookmark_remove, color: Colors.redAccent),
                  onPressed: () => context.read<MovieCubit>().toggleSave(userId, movie),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
