import 'package:fitness_app/core/widget/shared_card.dart';
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
    return  SharedCard(
      title: title,
      imageUrl: imageUrl,
      onTap: onTap,
      width: 120,
      margin: const EdgeInsets.only(right: 15),
    );
  }
}
