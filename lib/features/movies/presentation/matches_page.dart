import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_endpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/user_avatar.dart';
import '../bloc/movie_cubit.dart';
import '../../../core/database/app_database.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  Widget _buildMatchPosterPlaceholder() {
    return Container(
      width: AppDimensions.matchCardPosterWidth,
      height: AppDimensions.matchCardPosterHeight,
      color: AppColors.surfaceLight,
      child: const Icon(Icons.movie, color: AppColors.primaryGold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.matchesTitle),
      ),
      body: SafeArea(
        child: StreamBuilder<int>(
        stream: context.read<MovieCubit>().watchTotalUserCount(),
        builder: (context, totalUsersSnapshot) {
          final totalUsers = totalUsersSnapshot.data ?? 0;
          
          return StreamBuilder<List<({Movie movie, List<User> users})>>(
            stream: context.read<MovieCubit>().watchMatches(),
            builder: (context, snapshot) {
              final matches = snapshot.data ?? [];
              if (matches.isEmpty) {
                return _buildEmptyState(context);
              }

              return AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    final isGroupPick = totalUsers > 0 && match.users.length == totalUsers;

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: AppConstants.durationStaggerMs),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                            decoration: isGroupPick
                                ? BoxDecoration(
                                    border: Border.all(color: AppColors.primaryGold, width: 2),
                                    borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                                  )
                                : null,
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  context.push('/movie/${match.movie.id}');
                                },
                                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppDimensions.spacingS),
                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: 'movie-poster-${match.movie.id}',
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(AppDimensions.imageRadius),
                                          child: match.movie.posterPath?.isNotEmpty == true
                                              ? CachedNetworkImage(
                                                  imageUrl: '${AppEndpoints.tmdbImageBaseW185}${match.movie.posterPath}',
                                                  width: AppDimensions.matchCardPosterWidth,
                                                  height: AppDimensions.matchCardPosterHeight,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url, error) => _buildMatchPosterPlaceholder(),
                                                )
                                              : _buildMatchPosterPlaceholder(),
                                        ),
                                      ),
                                      const SizedBox(width: AppDimensions.spacingM),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (isGroupPick)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: AppDimensions.spacingXS,
                                                  vertical: AppDimensions.spacingXXS,
                                                ),
                                                margin: const EdgeInsets.only(bottom: AppDimensions.spacingXS),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryGold,
                                                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                                ),
                                                child: const Text(
                                                  AppStrings.topPick,
                                                  style: TextStyle(
                                                    color: AppColors.onPrimary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              match.movie.title,
                                              style: Theme.of(context).textTheme.titleLarge,
                                            ),
                                            const SizedBox(height: AppDimensions.spacingXS),
                                            AnimatedSwitcher(
                                              duration: const Duration(milliseconds: AppConstants.durationMediumMs),
                                              child: Text(
                                                '${match.users.length} saves',
                                                key: ValueKey<int>(match.users.length),
                                                style: const TextStyle(color: AppColors.primaryGold),
                                              ),
                                            ),
                                            const SizedBox(height: AppDimensions.spacingS),
                                            _buildUserAvatars(match.users),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
        },
      ),
    ));
  }

  Widget _buildUserAvatars(List<User> users) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingXXS),
            child: UserAvatar(
              avatarUrl: user.avatar,
              radius: AppDimensions.avatarRadiusS,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Icon(Icons.people_outline, size: 80, color: AppColors.textMuted),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            AppStrings.noMatchesFound,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ));
  }
}
