import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../database/app_database.dart';
import 'user_avatar.dart';

class SocialAvatars extends StatelessWidget {
  final List<User> users;

  const SocialAvatars({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();

    const double overlap = 12.0;
    const double avatarSize = 24.0;
    final int maxVisible = 2;
    final int extraCount = users.length - maxVisible;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: avatarSize,
          width: (users.length.clamp(1, maxVisible + (extraCount > 0 ? 1 : 0)) * (avatarSize - overlap)) + overlap,
          child: Stack(
            children: [
              ...users.take(maxVisible).toList().asMap().entries.map((entry) {
                final int index = entry.key;
                final User user = entry.value;
                return Positioned(
                  left: index * (avatarSize - overlap),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surfaceGrey,
                        width: 2,
                      ),
                    ),
                    child: UserAvatar(
                      avatarUrl: user.avatar,
                      radius: (avatarSize - 4) / 2,
                    ),
                  ),
                );
              }),
              if (extraCount > 0)
                Positioned(
                  left: maxVisible * (avatarSize - overlap),
                  child: Container(
                    height: avatarSize,
                    width: avatarSize,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surfaceGrey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+$extraCount',
                        style: const TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
