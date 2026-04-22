import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:flutter/material.dart';

class ExerciseCardWidget extends StatelessWidget {
  final ExerciseEntity exercise;
  final VoidCallback? onPlayTapped;

  const ExerciseCardWidget({
    super.key,
    required this.exercise,
    required this.onPlayTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─────────────────────────────────────────────
          // Thumbnail
          // ─────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ThumbnailWidget(thumbnailUrl: exercise.thumbnailUrl),
          ),

          const SizedBox(width: 16),

          // ─────────────────────────────────────────────
          // Info
          // ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercise.sets} ${context.l10n.groups} * ${exercise.reps} ${context.l10n.times}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  exercise.description,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.light400,
                        fontSize: 14,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),


          PlayButton(onTap: onPlayTapped),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Thumbnail Widget
// ─────────────────────────────────────────────
class ThumbnailWidget extends StatelessWidget {
  final String thumbnailUrl;

  const ThumbnailWidget({required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    if (!thumbnailUrl.startsWith('http')) {
      return Image.asset(
        thumbnailUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return CachedNetworkImage(
      imageUrl: thumbnailUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      placeholder: (_, __) => const SizedBox(
        width: 80,
        height: 80,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),

      errorWidget: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.grayDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.videocam_outlined,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Play Button Widget
// ─────────────────────────────────────────────
class PlayButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PlayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.grayMid,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: isEnabled ? AppColors.playIconColor : AppColors.light400,
          size: 20,
        ),
      ),
    );
  }
}
