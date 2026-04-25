import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        final user = state.user;

        final userName = user?.firstName ?? "User";
        final imageUrl = user?.photo ?? "";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
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
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          )
                        ),
                        const SizedBox(height: 8),
                          Text(
                           context.l10n.letsStart,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.white,
                           )
                        ),
                      ],
                    ),
                  ),
                  /// IMAGE
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null,
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}