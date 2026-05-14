import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';

class ProfileUserCard extends StatelessWidget {
  final UserEntity user;

  const ProfileUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = user.photo;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.grayMid,
          backgroundImage: imageUrl.isNotEmpty
              ? getImage(imageUrl)
              : null,
          child: imageUrl.isEmpty
              ? const Icon(Icons.person, color: AppColors.white)
              : null,
        ),

        const SizedBox(height: 12),

        Text(
          '${user.firstName} ${user.lastName}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
           ),
        ),
      ],
    );
  }
  ImageProvider getImage(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }
}