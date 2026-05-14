import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class HomeFoodCategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const HomeFoodCategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.grayMid,
                  highlightColor: AppColors.grayLight,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.fastfood, color: AppColors.grayLight),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SharedContainer(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
