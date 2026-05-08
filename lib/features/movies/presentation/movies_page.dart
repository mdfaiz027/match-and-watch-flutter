import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/movie_cubit.dart';
import '../../users/bloc/active_user_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _saveButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<MovieCubit>().loadMovies();
    _scrollController.addListener(_onScroll);
  }

  void _checkShowcase() {
    final prefs = sl<SharedPreferences>();
    final hasSeenTutorial = prefs.getBool('hasSeenMoviesTutorial') ?? false;
    if (!hasSeenTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_saveButtonKey]);
        prefs.setBool('hasSeenMoviesTutorial', true);
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MovieCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () {
              context.push('/saved_movies');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<MovieCubit, MovieState>(
          listener: (context, state) {
            if (state is MovieLoaded && state.movies.isNotEmpty) {
              _checkShowcase();
            }
          },
          builder: (context, state) {
            if (state is MovieLoading) {
              return _buildShimmerList();
            } else if (state is MovieLoaded) {
              final movies = state.movies;
              if (movies.isEmpty) {
                return const Center(child: Text('No movies found.'));
              }
              return AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _MovieCard(
                            movie: movie,
                            saveButtonKey: index == 0 ? _saveButtonKey : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is MovieError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 80, color: AppTheme.cinematicGold),
                      const SizedBox(height: 24),
                      Text(
                        'No Connection',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Please connect to the internet to load the initial feed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.read<MovieCubit>().loadMovies(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[900]!,
          highlightColor: Colors.grey[800]!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  final GlobalKey? saveButtonKey;

  const _MovieCard({required this.movie, this.saveButtonKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveUserCubit, User?>(
      builder: (context, activeUser) {
        final userId = activeUser?.id ?? 0;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () {
              context.push('/movie/${movie.id}');
            },
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Hero(
                  tag: 'movie-poster-${movie.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath != null
                          ? 'https://image.tmdb.org/t/p/w185${movie.posterPath}'
                          : '',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 150,
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie, color: AppTheme.cinematicGold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          movie.releaseYear ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            StreamBuilder<int>(
                              stream: context.read<MovieCubit>().getSaveCount(movie.id),
                              builder: (context, snapshot) {
                                final count = snapshot.data ?? 0;
                                return Badge(
                                  label: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return ScaleTransition(scale: animation, child: child);
                                    },
                                    child: Text(
                                      count.toString(),
                                      key: ValueKey<int>(count),
                                    ),
                                  ),
                                  isLabelVisible: count > 0,
                                  backgroundColor: AppTheme.cinematicGold,
                                  child: StreamBuilder<bool>(
                                    stream: context.read<MovieCubit>().isSaved(userId, movie.id),
                                    builder: (context, snapshot) {
                                      final isSaved = snapshot.data ?? false;
                                      final iconButton = IconButton(
                                        icon: Icon(
                                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                                          color: isSaved ? AppTheme.cinematicGold : null,
                                        ),
                                        onPressed: () {
                                          if (userId != 0) {
                                            context.read<MovieCubit>().toggleSave(userId, movie);
                                          }
                                        },
                                      );

                                      if (saveButtonKey != null) {
                                        return Showcase(
                                          key: saveButtonKey!,
                                          title: 'Save Movie',
                                          description: 'Tap to save a movie to your offline list.',
                                          tooltipBackgroundColor: AppTheme.surfaceGrey,
                                          textColor: Colors.white,
                                          titleTextStyle: const TextStyle(
                                            color: AppTheme.cinematicGold,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          descTextStyle: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                          onTargetClick: () {
                                            HapticFeedback.lightImpact();
                                            if (userId != 0) {
                                              context.read<MovieCubit>().toggleSave(userId, movie);
                                            }
                                          },
                                          disposeOnTap: true,
                                          child: iconButton,
                                        );
                                      }
                                      return iconButton;
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
