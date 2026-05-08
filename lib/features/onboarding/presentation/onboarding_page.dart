import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../bloc/onboarding_cubit.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 2;
              });
            },
            children: [
              _OnboardingStep(
                controller: _pageController,
                index: 0,
                animation: AppAssets.movieAnim,
                title: AppStrings.onboardingDiscoverTitle,
                description: AppStrings.onboardingDiscoverDesc,
                lottieHeight: 320,
              ),
              _OnboardingStep(
                controller: _pageController,
                index: 1,
                animation: AppAssets.offlineAnim,
                title: AppStrings.onboardingOfflineTitle,
                description: AppStrings.onboardingOfflineDesc,
                lottieHeight: 240,
              ),
              _OnboardingStep(
                controller: _pageController,
                index: 2,
                animation: AppAssets.matchAnim,
                title: AppStrings.onboardingMatchTitle,
                description: AppStrings.onboardingMatchDesc,
                lottieHeight: 300,
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryGold,
                    dotColor: Colors.white24,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXXL),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: AppConstants.durationMediumMs),
                    child: _isLastPage
                        ? SizedBox(
                            key: const ValueKey('get_started_btn'),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await context.read<OnboardingCubit>().completeOnboarding();
                                if (context.mounted) {
                                  context.go('/');
                                }
                              },
                              child: const Text(AppStrings.getStarted),
                            ),
                          )
                        : SizedBox(
                            key: const ValueKey('next_btn'),
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: AppConstants.durationSlowMs),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                AppStrings.next,
                                style: TextStyle(
                                  color: AppColors.primaryGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  final PageController controller;
  final int index;
  final String animation;
  final String title;
  final String description;
  final double lottieHeight;

  const _OnboardingStep({
    required this.controller,
    required this.index,
    required this.animation,
    required this.title,
    required this.description,
    required this.lottieHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 0.0;
        if (controller.position.haveDimensions) {
          value = index.toDouble() - (controller.page ?? 0);
        }
        
        // Premium transition effect: Scale and Fade
        final double opacity = (1.0 - (value.abs() * 0.5)).clamp(0.0, 1.0);
        final double scale = (1.0 - (value.abs() * 0.2)).clamp(0.8, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: lottieHeight,
                    child: Lottie.asset(
                      animation,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.movie_outlined,
                          size: 120,
                          color: AppColors.primaryGold,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXXL),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryGold,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
