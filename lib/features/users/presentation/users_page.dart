import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/user_cubit.dart';
import '../bloc/active_user_cubit.dart';
import '../../../core/theme/app_theme.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _addUserKey = GlobalKey();
  final GlobalKey _matchesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUsers();
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkShowcase();
    });
  }

  void _checkShowcase() {
    final prefs = sl<SharedPreferences>();
    final hasSeenTutorial = prefs.getBool('hasSeenUsersTutorial') ?? false;
    if (!hasSeenTutorial) {
      ShowCaseWidget.of(context).startShowCase([_addUserKey, _matchesKey]);
      prefs.setBool('hasSeenUsersTutorial', true);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UserCubit>().loadNextPage();
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
        title: const Text('Match & Watch Users'),
        actions: [
          Showcase(
            key: _matchesKey,
            title: 'Matches',
            description: 'Tap here to see which movies everyone wants to watch!',
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                context.push('/matches');
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return _buildShimmerList();
            } else if (state is UserLoaded) {
              final users = state.users;
              if (users.isEmpty) {
                return const Center(child: Text('No users found.'));
              }
              return AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final item = users[index];
                    final user = item.user;
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              onTap: () {
                                context.read<ActiveUserCubit>().setUser(user);
                                context.push('/movies');
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: CachedNetworkImage(
                                  imageUrl: user.avatar ?? '',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.person, color: Colors.white54),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.person, color: AppTheme.cinematicGold),
                                  ),
                                  fadeInDuration: const Duration(milliseconds: 500),
                                ),
                              ),
                              title: Text(
                                '${user.firstName} ${user.lastName}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                'Saved movies: ${item.movieCount}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is UserError) {
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
                        onPressed: () => context.read<UserCubit>().loadUsers(),
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
      floatingActionButton: Showcase(
        key: _addUserKey,
        title: 'New User',
        description: 'Start here! Create a profile to start saving movies.',
        child: FloatingActionButton(
          backgroundColor: AppTheme.cinematicGold,
          onPressed: () => context.push('/add_user'),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[900]!,
          highlightColor: Colors.grey[800]!,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.white),
              title: Container(
                height: 16,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              subtitle: Container(
                height: 12,
                width: 100,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
