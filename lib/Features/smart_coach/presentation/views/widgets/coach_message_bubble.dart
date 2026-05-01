import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Left-aligned AI coach message bubble.
///
/// Layout: [avatar circle] — [frosted bubble with text]
class CoachMessageBubble extends StatelessWidget {
  final String message;
  final bool isPartial;

  const CoachMessageBubble({
    super.key,
    required this.message,
    this.isPartial = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ── Coach avatar ──
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.grayMid,
          child: Image.asset(
            Assets.images.robot.path,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 8),

        /// ── Message bubble ──
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: SharedContainer(
            borderRadius: 16,
            blur: 10,
            opacity: 0.3,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),

                /// Partial indicator for interrupted messages
                if (isPartial) ...[
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.smartCoachPartialMessage,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.orange500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
