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
            padding: const EdgeInsets.all(AppDimensions.spacingM),
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
                      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                      child: ListTile(
                        leading: Hero(
                          tag: 'movie-poster-${movie.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterPath != null
                                  ? '${AppEndpoints.tmdbImageBaseW185}${movie.posterPath}'
                                  : '',
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                width: 50,
                                height: 75,
                                color: AppColors.surfaceLight,
                                child: const Icon(Icons.movie, color: AppColors.primaryGold, size: 20),
                              ),
                            ),
                          ),
                        ),
                        title: Text(movie.title, style: Theme.of(context).textTheme.titleLarge),
                        onTap: () {
                          context.push('/movie/${movie.id}');
                        },
                        trailing: StreamBuilder<bool>(
                          stream: context.read<MovieCubit>().isSaved(activeUserId, movie.id),
                          builder: (context, isSavedSnapshot) {
                            final isSavedByActiveUser = isSavedSnapshot.data ?? false;
                            return IconButton(
                              icon: Icon(
                                isSavedByActiveUser ? Icons.bookmark : Icons.bookmark_border,
                                color: isSavedByActiveUser ? AppColors.primaryGold : Colors.grey,
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
