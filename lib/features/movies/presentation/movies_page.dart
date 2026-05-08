import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_endpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/movie_cubit.dart';
import '../../users/bloc/active_user_cubit.dart';
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
        title: const Text(AppStrings.moviesTitle),
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
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<MovieCubit>().loadMovies();
          },
          child: BlocConsumer<MovieCubit, MovieState>(
            listener: (context, state) {
              if (state is MovieLoaded && state.movies.isNotEmpty) {
                final prefs = sl<SharedPreferences>();
                final hasSeenTutorial = prefs.getBool('hasSeenMoviesTutorial') ?? false;
                if (!hasSeenTutorial) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ShowCaseWidget.of(context).startShowCase([_saveButtonKey]);
                    prefs.setBool('hasSeenMoviesTutorial', true);
                  });
                }
              }
            },
            builder: (context, state) {
              if (state is MovieLoading) {
                return _buildShimmerList();
              } else if (state is MovieLoaded) {
                final movies = state.movies;
                if (movies.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      Center(
                        child: Column(
                          children: [
                            const Text(AppStrings.noMoviesFound),
                            const SizedBox(height: AppDimensions.spacingM),
                            ElevatedButton(
                              onPressed: () => context.read<MovieCubit>().loadMovies(),
                              child: const Text(AppStrings.retry),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: AppConstants.durationStaggerMs),
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
                  padding: const EdgeInsets.all(AppDimensions.spacingXL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 80, color: AppColors.primaryGold),
                      const SizedBox(height: AppDimensions.spacingL),
                      Text(
                        AppStrings.noConnection,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacingS),
                      const Text(
                        AppStrings.noConnectionDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),
                      ElevatedButton(
                        onPressed: () => context.read<MovieCubit>().loadMovies(),
                        child: const Text(AppStrings.retry),
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
    ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingXS,
            ),
            height: AppDimensions.movieCardHeight,
            decoration: BoxDecoration(
              color: AppColors.textMain,
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
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
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingXS,
          ),
          child: InkWell(
            onTap: () {
              context.push('/movie/${movie.id}');
            },
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            child: Row(
              children: [
                Hero(
                  tag: 'movie-poster-${movie.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.cardRadius),
                      bottomLeft: Radius.circular(AppDimensions.cardRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath != null
                          ? '${AppEndpoints.tmdbImageBaseW185}${movie.posterPath}'
                          : '',
                      width: AppDimensions.moviePosterWidth,
                      height: AppDimensions.movieCardHeight,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: AppDimensions.moviePosterWidth,
                        height: AppDimensions.movieCardHeight,
                        color: AppColors.surfaceLight,
                        child: const Icon(Icons.movie, color: AppColors.primaryGold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimensions.spacingXXS),
                        Text(
                          movie.releaseYear ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppDimensions.spacingXS),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            StreamBuilder<int>(
                              stream: context.read<MovieCubit>().getSaveCount(movie.id),
                              builder: (context, snapshot) {
                                final count = snapshot.data ?? 0;
                                return Badge(
                                  label: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: AppConstants.durationMediumMs),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return ScaleTransition(scale: animation, child: child);
                                    },
                                    child: Text(
                                      count.toString(),
                                      key: ValueKey<int>(count),
                                    ),
                                  ),
                                  isLabelVisible: count > 0,
                                  backgroundColor: AppColors.primaryGold,
                                  child: StreamBuilder<bool>(
                                    stream: context.read<MovieCubit>().isSaved(userId, movie.id),
                                    builder: (context, snapshot) {
                                      final isSaved = snapshot.data ?? false;
                                      final iconButton = IconButton(
                                        icon: Icon(
                                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                                          color: isSaved ? AppColors.primaryGold : null,
                                        ),
                                        onPressed: () {
                                          if (userId != 0) {
                                            HapticFeedback.lightImpact();
                                            context.read<MovieCubit>().toggleSave(userId, movie);
                                            
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(isSaved ? AppStrings.removedFromSaved : AppStrings.movieSaved),
                                                duration: const Duration(seconds: 1),
                                                backgroundColor: AppColors.primaryGold,
                                              ),
                                            );
                                          }
                                        },
                                      );

                                      if (saveButtonKey != null) {
                                        return Showcase(
                                          key: saveButtonKey!,
                                          title: AppStrings.tutorialSaveMovieTitle,
                                          description: AppStrings.tutorialSaveMovieDesc,
                                          tooltipBackgroundColor: AppColors.surfaceGrey,
                                          textColor: AppColors.onSurface,
                                          titleTextStyle: const TextStyle(
                                            color: AppColors.primaryGold,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          descTextStyle: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14,
                                          ),
                                          onTargetClick: () {
                                            HapticFeedback.lightImpact();
                                            if (userId != 0) {
                                              context.read<MovieCubit>().toggleSave(userId, movie);
                                              
                                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text(AppStrings.movieSaved),
                                                  duration: Duration(seconds: 1),
                                                  backgroundColor: AppColors.primaryGold,
                                                ),
                                              );
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
