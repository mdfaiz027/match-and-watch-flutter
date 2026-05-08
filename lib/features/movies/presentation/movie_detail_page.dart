import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_endpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/user_avatar.dart';
import '../bloc/movie_cubit.dart';
import '../../users/bloc/active_user_cubit.dart';
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

  Widget _buildDetailPosterPlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: const Icon(Icons.movie, size: 100, color: AppColors.primaryGold),
    );
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

          return SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: AppDimensions.appBarExpandedHeight,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'movie-poster-${movie.id}',
                      child: movie.posterPath?.isNotEmpty == true
                          ? CachedNetworkImage(
                              imageUrl: '${AppEndpoints.tmdbImageBaseW500}${movie.posterPath}',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => _buildDetailPosterPlaceholder(),
                            )
                          : _buildDetailPosterPlaceholder(),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
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
                                const SizedBox(height: AppDimensions.spacingXXS),
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
                                      color: isSaved ? AppColors.primaryGold : null,
                                      size: AppDimensions.iconSizeL,
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
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingL),
                      Text(
                        AppStrings.plot,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        movie.overview ?? AppStrings.noDescription,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),
                      _buildUsersWhoSaved(movie.id),
                    ]),
                  ),
                ),
              ],
            ),
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
              padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingL),
              child: Text(
                AppStrings.beFirstToSave,
                style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textMuted),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${users.length} ${AppStrings.usersWantToWatch}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: users.map((user) => Padding(
                  padding: const EdgeInsets.only(right: AppDimensions.spacingXS),
                  child: UserAvatar(
                    avatarUrl: user.avatar,
                    radius: AppDimensions.avatarRadiusM,
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
