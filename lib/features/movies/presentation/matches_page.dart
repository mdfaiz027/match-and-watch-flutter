import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/movie_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Matches'),
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

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  final isGroupPick = totalUsers > 0 && match.users.length == totalUsers;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: isGroupPick
                        ? BoxDecoration(
                            border: Border.all(color: AppTheme.cinematicGold, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          )
                        : null,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: match.movie.posterPath != null
                                    ? 'https://image.tmdb.org/t/p/w185${match.movie.posterPath}'
                                    : '',
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.movie, color: AppTheme.cinematicGold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isGroupPick)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.cinematicGold,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'GROUP PICK!',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    match.movie.title,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      '${match.users.length} saves',
                                      key: ValueKey<int>(match.users.length),
                                      style: const TextStyle(color: AppTheme.cinematicGold),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildUserAvatars(match.users),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
            padding: const EdgeInsets.only(right: 6),
            child: CachedNetworkImage(
              imageUrl: user.avatar ?? '',
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 15,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => const CircleAvatar(
                radius: 15,
                child: Icon(Icons.person, size: 15),
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 15,
                child: Icon(Icons.person, size: 15, color: AppTheme.cinematicGold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Icon(Icons.people_outline, size: 80, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            'No matches found.',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Matches happen when 2 or more users save the same movie. Start saving movies for different users to see them here!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ));
  }
}
