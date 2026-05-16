// ignore_for_file: unnecessary_underscores

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class ThumbnailWidget extends StatelessWidget {
  final String thumbnailUrl;

  const ThumbnailWidget({super.key, required this.thumbnailUrl});

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

    return SizedBox(
      width: 80,
      height: 80,
      child: CachedNetworkImage(
        imageUrl: thumbnailUrl,
        imageBuilder: (context, imageProvider) => Transform.scale(
          scale: 1.35,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (_, __) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
        errorWidget: (_, __, ___) => _placeholder(),
      ),
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
