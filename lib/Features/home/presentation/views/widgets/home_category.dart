import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
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
        const SizedBox(height:7),

        SharedContainer(
          child: SizedBox(
            height: 90,
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
                                height: 56,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.labelLarge!
                                    .copyWith(
                                      color: AppColors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (index != categories.length - 1)
                        Container(
                          width: 1,
                          height: 80,
                          color: AppColors.grayLight,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
