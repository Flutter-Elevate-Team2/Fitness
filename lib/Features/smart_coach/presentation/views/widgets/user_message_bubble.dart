import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';

/// Right-aligned user message bubble.
///
/// Layout: [primary-colored bubble with text] — [user avatar circle]
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
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.grayMid,
          child: Icon(Icons.person, color: AppColors.white, size: 18),
        ),
      ],
    );
  }
}
