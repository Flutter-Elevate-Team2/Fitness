import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CategoryItem {
  final String title;
  final String image;
  final bool isAvailable;
  CategoryItem({
    required this.title,
    required this.image,
    required this.isAvailable,
  });
}

class CategorySection extends StatefulWidget {
  final void Function({String? selectedGroupId})? onTapGym;

  const CategorySection({super.key, this.onTapGym});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int? lockedIndex;

  @override
  Widget build(BuildContext context) {
    final List<CategoryItem> categories = [
      CategoryItem(
        title: context.l10n.gym,
        image: Assets.images.gym.path,
        isAvailable: true,
      ),
      CategoryItem(
        title: context.l10n.yoga,
        image: Assets.images.yoga.path,
        isAvailable: false,
      ),
      CategoryItem(
        title: context.l10n.aerobics,
        image: Assets.images.aerobics.path,
        isAvailable: false,
      ),
      CategoryItem(
        title: context.l10n.trainer,
        image: Assets.images.trainer.path,
        isAvailable: true,
      ),
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
        const SizedBox(height: 10),
        Container(
          height: 85,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: List.generate(categories.length, (index) {
              final item = categories[index];
              final isShowingSoon = lockedIndex == index;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              if (item.isAvailable) {
                                if (item.title == context.l10n.gym &&
                                    widget.onTapGym != null) {
                                  widget.onTapGym!();
                                } else {
                                  _handleNavigation(context, item.title);
                                }
                              } else {
                                _showSoonOverlay(index);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(item.image, height: 35),
                                const SizedBox(height: 6),
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // الـ Soon Tooltip
                          if (isShowingSoon)
                            Positioned(
                              top: -30,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: isShowingSoon ? 1.0 : 0.0,
                                child: SharedContainer(
                                  borderRadius: 12,
                                  blur: 10,
                                  opacity: 0.8,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        context.l10n.featureComingSoon,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      CustomPaint(
                                        size: const Size(10, 5),
                                        painter: TrianglePainter(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (index != categories.length - 1)
                      Container(
                        width: 1,
                        height: 45,
                        color: AppColors.white.withValues(alpha: 0.1),
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

  void _showSoonOverlay(int index) {
    setState(() {
      lockedIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          lockedIndex = null;
        });
      }
    });
  }

  void _handleNavigation(BuildContext context, String title) {
    if (title == context.l10n.trainer) {
      // context.pushNamed(Routes.trainerName);
    }
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.blackSoft.withValues(alpha: 0.8);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
