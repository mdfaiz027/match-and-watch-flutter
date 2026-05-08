import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_endpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/user_avatar.dart';
import '../bloc/user_cubit.dart';
import '../bloc/active_user_cubit.dart';
import '../../movies/bloc/movie_cubit.dart';
import '../../../core/database/app_database.dart';

class SavedMoviesPage extends StatelessWidget {
  final int? profileUserId;

  const SavedMoviesPage({super.key, this.profileUserId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveUserCubit, User?>(
      builder: (context, activeUser) {
        if (activeUser == null) {
          return const Scaffold(
            body: Center(child: Text('No active user selected.')),
          );
        }

        // If profileUserId is null, we are viewing the active user's own profile.
        final effectiveProfileUserId = profileUserId ?? activeUser.id;
        final isOwnProfile = effectiveProfileUserId == activeUser.id;

        return Scaffold(
          appBar: AppBar(
            title: Text(isOwnProfile ? 'My ${AppStrings.savedMoviesTitle}' : AppStrings.savedMoviesTitle),
          ),
          body: SafeArea(
            child: StreamBuilder<User?>(
            stream: context.read<UserCubit>().watchUserById(effectiveProfileUserId),
            builder: (context, userSnapshot) {
              final user = userSnapshot.data;
              if (user == null) return const Center(child: CircularProgressIndicator());

              return Column(
                children: [
                  _buildHeader(context, user),
                  Expanded(child: _buildSavedList(context, activeUser.id, effectiveProfileUserId)),
                ],
              );
            },
          ),
        )
        );
      },
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      width: AppDimensions.moviePosterWidth,
      height: AppDimensions.movieCardHeight,
      color: AppColors.surfaceLight,
      child: const Icon(Icons.movie, color: AppColors.primaryGold),
    );
  }

  Widget _buildHeader(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      color: AppColors.surfaceGrey,
      child: Row(
        children: [
          UserAvatar(
            avatarUrl: user.avatar,
            radius: AppDimensions.avatarRadiusL,
          ),
          const SizedBox(width: AppDimensions.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppDimensions.spacingXXS),
                Text(
                  'Taste: ${user.movieTaste}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryGold,
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

  Widget _buildSavedList(BuildContext context, int activeUserId, int profileUserId) {
    return StreamBuilder<List<Movie>>(
      stream: context.read<MovieCubit>().watchSavedMovies(profileUserId),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        if (movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie_filter, size: 80, color: AppColors.textMuted),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  'No saved movies yet.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'Start browsing and save some!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: AppConstants.durationStaggerMs),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Card(
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
                                child: movie.posterPath?.isNotEmpty == true
                                    ? CachedNetworkImage(
                                        imageUrl: '${AppEndpoints.tmdbImageBaseW185}${movie.posterPath}',
                                        width: AppDimensions.moviePosterWidth,
                                        height: AppDimensions.movieCardHeight,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => _buildPosterPlaceholder(),
                                      )
                                    : _buildPosterPlaceholder(),
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
                                                stream: context.read<MovieCubit>().isSaved(activeUserId, movie.id),
                                                builder: (context, isSavedSnapshot) {
                                                  final isSavedByActiveUser = isSavedSnapshot.data ?? false;
                                                  return IconButton(
                                                    icon: Icon(
                                                      isSavedByActiveUser ? Icons.bookmark : Icons.bookmark_border,
                                                      color: isSavedByActiveUser ? AppColors.primaryGold : null,
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback.lightImpact();
                                                      context.read<MovieCubit>().toggleSave(activeUserId, movie);
                                                      
                                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(isSavedByActiveUser ? AppStrings.removedFromSaved : AppStrings.movieSaved),
                                                          duration: const Duration(seconds: 1),
                                                          backgroundColor: AppColors.primaryGold,
                                                        ),
                                                      );
                                                    },
                                                  );
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
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
