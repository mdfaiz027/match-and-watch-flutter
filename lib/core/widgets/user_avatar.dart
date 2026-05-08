import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final IconData placeholderIcon;

  const UserAvatar({
    super.key,
    required this.avatarUrl,
    required this.radius,
    this.placeholderIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    if (avatarUrl!.startsWith('assets/')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(avatarUrl!),
        backgroundColor: AppColors.surfaceLight,
      );
    }

    return CachedNetworkImage(
      imageUrl: avatarUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildPlaceholder(error: true),
    );
  }

  Widget _buildPlaceholder({bool error = false}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceLight,
      child: Icon(
        placeholderIcon,
        color: error ? AppColors.primaryGold : AppColors.textMuted,
        size: radius * 1.2,
      ),
    );
  }
}
