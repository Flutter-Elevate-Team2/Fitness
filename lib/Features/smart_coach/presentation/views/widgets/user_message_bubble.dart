import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/user_cubit/user_view_model.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';

class UserMessageBubble extends StatelessWidget {
  final String message;

  const UserMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ── Message bubble ──
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: SharedContainer(
            borderRadius: 16,
            blur: 0,
            opacity: .50,
            color: AppColors.userBubbleColor,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              message,
              style: AppTypography.bodyLarge.copyWith(color: AppColors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),

        /// ── User avatar ──
        // استخدمنا BlocBuilder عشان نقرأ صورة اليوزر فوراً
        BlocBuilder<UserCubit, UserEntity?>(
          builder: (context, user) {
            final imageUrl = user?.photo ?? "";

            return CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.grayMid,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, color: AppColors.white, size: 18)
                  : null,
            );
          },
        ),
      ],
    );
  }
}
