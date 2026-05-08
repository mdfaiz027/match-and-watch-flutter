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
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/user_cubit.dart';
import '../bloc/active_user_cubit.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _fabKey = GlobalKey();
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
      ShowCaseWidget.of(context).startShowCase([_fabKey, _matchesKey]);
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
        title: const Text(AppStrings.usersTitle),
        actions: [
          Showcase(
            key: _matchesKey,
            title: AppStrings.tutorialMatchesTitle,
            description: AppStrings.tutorialMatchesDesc,
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
            targetShapeBorder: const CircleBorder(),
            onTargetClick: () {
              HapticFeedback.lightImpact();
              context.push('/matches');
            },
            disposeOnTap: true,
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
                return const Center(child: Text(AppStrings.noUsersFound));
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
                      duration: const Duration(milliseconds: AppConstants.durationStaggerMs),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingM,
                              vertical: AppDimensions.spacingXS,
                            ),
                            child: ListTile(
                              onTap: () {
                                context.read<ActiveUserCubit>().setUser(user);
                                context.push('/movies');
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                                child: CachedNetworkImage(
                                  imageUrl: user.avatar ?? '',
                                  width: AppDimensions.iconSizeXL,
                                  height: AppDimensions.iconSizeXL,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppColors.surfaceLight,
                                    child: const Icon(Icons.person, color: AppColors.textMuted),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: AppColors.surfaceLight,
                                    child: const Icon(Icons.person, color: AppColors.primaryGold),
                                  ),
                                  fadeInDuration: const Duration(milliseconds: AppConstants.durationSlowMs),
                                ),
                              ),
                              title: Text(
                                '${user.firstName} ${user.lastName}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                '${AppStrings.savedMoviesCount}${item.movieCount}',
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
                        onPressed: () => context.read<UserCubit>().loadUsers(),
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
      floatingActionButton: Showcase(
        key: _fabKey,
        title: AppStrings.tutorialNewUserTitle,
        description: AppStrings.tutorialNewUserDesc,
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
          context.push('/add_user');
        },
        disposeOnTap: true,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryGold,
          onPressed: () => context.push('/add_user'),
          child: const Icon(Icons.add, color: AppColors.onPrimary),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingXS,
            ),
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
