import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MuscleCard extends StatelessWidget {
  final MuscleEntity muscle;
  final VoidCallback? onTap;

  const MuscleCard({
    super.key,
    required this.muscle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.grayDark, // fallback background
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [

          if (muscle.image != null && muscle.image!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: muscle.image!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.grayMid,
                highlightColor: AppColors.grayLight,
                child: Container(color: Colors.white),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, color: AppColors.grayLight),
            )
          else
            const Center(
              child: Icon(Icons.fitness_center, color: AppColors.grayLight, size: 50),
            ),


          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black87,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 0.6],
              ),
            ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text(
                muscle.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
