import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/shared_text_item.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/core/extension/context_extention.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<String> goals = [
      context.l10n.gainWeight,
      context.l10n.loseWeight,
      context.l10n.getFitter,
      context.l10n.gainMoreFlexible,
      context.l10n.learnTheBasic,
    ];

    return SharedScaffold(
      backgroundImage: AppAssets.authBackground,
      title: Image.asset(AppAssets.authLogo),
      appBarTopPadding: 24.0,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            CustomStepProgress(currentStep: 5,),
            const SizedBox(height: 16),
            SharedTextItem(
              title: context.l10n.whatIsYourGoal,
              subTitle: context.l10n.personalizedPlanNote,
            ),
            const SizedBox(height: 16),
            SharedContainer(
              isTopOnly: false,
              borderRadius: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(goals.length, (index) {
                    return CustomSelectionTile(
                      title: goals[index],
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                         selectedIndex = (selectedIndex == index) ? null : index;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  CustomButton(
                    title: context.l10n.next,
                    onPressed: selectedIndex != null
                        ? () {
                            AppRouter.router.goNamed(Routes.activityName);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
