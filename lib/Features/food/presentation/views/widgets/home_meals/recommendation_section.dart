import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart'; 
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class RecommendationForYouSection extends StatelessWidget {
  final BaseResponse<HomeSection>? response;

  const RecommendationForYouSection({super.key, this.response});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _buildHeader(context),

        const SizedBox(height: 10),


        _buildContent(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    List<CategoryEntity> categories = [];
    if (response is SuccessResponse<HomeSection>) {
      categories =
          (response as SuccessResponse<HomeSection>).data
              is FoodCategoriesSection
          ? ((response as SuccessResponse<HomeSection>).data
                    as FoodCategoriesSection)
                .categories
          : [];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.recommendationForYou,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            if (categories.isEmpty) return;
            context.pushNamed(
              Routes.mealsName,
              extra: MealsNavArgs(
                selectedCategory: categories.first.name,
                categories: categories.map((c) => c.name).toList(),
              ),
            );
          },
          child: Text(
            context.l10n.seeAll,
            style: const TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return switch (response) {
      null => _buildShimmer(),

      SuccessResponse(data: var section) => _buildList(
        (section as FoodCategoriesSection).categories,
      ),

      ErrorResponse(errorMessage: var msg) => SizedBox(
        height: 120,
        child: Center(
          child: Text(
            msg,
            style: const TextStyle(color: AppColors.red, fontSize: 12),
          ),
        ),
      ),
    };
  }

  Widget _buildList(List<CategoryEntity> categories) {
    if (categories.isEmpty) return const SizedBox(height: 120);

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return SharedCard(
            title: category.name,
            imageUrl: category.image,
            onTap: () {
              context.pushNamed(
                Routes.mealsName,
                extra: MealsNavArgs(
                  selectedCategory: category.name,
                  categories: categories.map((c) => c.name).toList(),
                ),
              );
            },
            width: 130,
            height: 120,
            borderRadius: 16,
            margin: const EdgeInsets.only(right: 15),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.grayMid,
            highlightColor: AppColors.grayLight,
            child: Container(
              width: 130,
              height: 120,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
