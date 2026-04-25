import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CategoryItem {
  final String title;
  final String image;

  CategoryItem({required this.title, required this.image});
}

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryItem> categories = [
      CategoryItem(title: context.l10n.gym, image: Assets.images.gym.path),
      CategoryItem(title: context.l10n.fitness, image: Assets.images.fitness.path),
      CategoryItem(title: context.l10n.yoga, image: Assets.images.yoga.path),
      CategoryItem(title: context.l10n.aerobics, image: Assets.images.aerobics.path),
      CategoryItem(title: context.l10n.trainer, image: Assets.images.trainer.path),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.category,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),

        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: List.generate(categories.length, (index) {
              final item = categories[index];

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              item.image,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    color: AppColors.white,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (index != categories.length - 1)
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.grayLight,
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
