import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../profile/domain/entities/user_entity.dart';

class HomeHeader extends StatelessWidget {
  final BaseResponse<HomeSection>? response;

  const HomeHeader({super.key, this.response});

  @override
  Widget build(BuildContext context) {
    return switch (response) {
      null => _buildShimmer(context),

      SuccessResponse(data: var section) => _buildContent(
        context,
        (section as UserProfileSection).user,
      ),

      ErrorResponse() => _buildContent(context, null),
    };
  }

  Widget _buildContent(BuildContext context, UserEntity? user) {
    final userName = user?.firstName ?? context.l10n.profile;
    final imageUrl = user?.photo ?? "";

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          /// TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${context.l10n.hi} $userName ,",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.letsStart,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          /// IMAGE
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.grayMid,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person, color: AppColors.white)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grayMid,
      highlightColor: AppColors.grayLight,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 80, height: 14, color: AppColors.white),
                const SizedBox(height: 10),
                Container(width: 150, height: 20, color: AppColors.white),
              ],
            ),
          ),
          const CircleAvatar(radius: 24, backgroundColor: AppColors.white),
        ],
      ),
    );
  }
}
