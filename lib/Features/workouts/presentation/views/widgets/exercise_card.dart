import 'package:fitness_app/Features/workouts/presentation/views/widgets/play_back_button.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/thumbanil_widget.dart';
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

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ThumbnailWidget(thumbnailUrl: exercise.thumbnailUrl),
          ),

          const SizedBox(width: 16),


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

