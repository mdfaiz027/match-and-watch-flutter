import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/movie_cubit.dart';
import '../../users/bloc/active_user_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieCubit>().loadMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Movie?>(
        stream: context.read<MovieCubit>().getMovieById(widget.movieId),
        builder: (context, snapshot) {
          final movie = snapshot.data;
          if (movie == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'movie-poster-${movie.id}',
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath != null
                          ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                          : '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie, size: 100, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                movie.releaseYear ?? '',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<ActiveUserCubit, User?>(
                          builder: (context, activeUser) {
                            final userId = activeUser?.id ?? 0;
                            return StreamBuilder<bool>(
                              stream: context.read<MovieCubit>().isSaved(userId, movie.id),
                              builder: (context, snapshot) {
                                final isSaved = snapshot.data ?? false;
                                return IconButton(
                                  icon: Icon(
                                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                                    color: isSaved ? AppTheme.cinematicGold : null,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    if (userId != 0) {
                                      context.read<MovieCubit>().toggleSave(userId, movie);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Plot',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview ?? 'No description available.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    _buildUsersWhoSaved(movie.id),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUsersWhoSaved(int movieId) {
    return StreamBuilder<List<User>>(
      stream: context.read<MovieCubit>().getUsersWhoSaved(movieId),
      builder: (context, snapshot) {
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Be the first to save this.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${users.length} users want to watch this',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: users.map((user) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CachedNetworkImage(
                    imageUrl: user.avatar ?? '',
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
