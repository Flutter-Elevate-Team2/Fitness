import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SharedCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool useCachedImage;

  const SharedCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.width = 120,
    this.height = 150,
    this.margin,
    this.borderRadius = 20,
    this.useCachedImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Image
              useCachedImage
                  ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.grayMid,
                  highlightColor: AppColors.grayLight,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.fastfood,
                    color: AppColors.grayLight),
              )
                  : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

              /// Title Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SharedContainer(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
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