import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_avatar.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/user_entity.dart';

class UserInfoSection extends StatelessWidget {
  final UserEntity? currentUser;

  const UserInfoSection({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatar(photoUrl: currentUser?.photo),
        const SizedBox(height: 12),
        Text(
          '${currentUser?.firstName ?? ""} ${currentUser?.lastName ?? ""}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
