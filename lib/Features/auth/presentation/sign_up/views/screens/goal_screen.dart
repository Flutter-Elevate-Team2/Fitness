import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  final int currentStep;
  final VoidCallback onNextStep;
  final VoidCallback onBackButtonPressed;

  const GoalScreen({
    super.key,
    required this.currentStep,
    required this.onNextStep,
    required this.onBackButtonPressed,
  });

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

    return SharedAuthLayout(
      onBackPressed: widget.onBackButtonPressed,
      title: context.l10n.whatIsYourGoal,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.next,
      onButtonPressed: selectedIndex != null ? widget.onNextStep : null,
      stepIndicator: CustomStepProgress(currentStep: widget.currentStep),
      formBody: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(goals.length, (index) {
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
      ),
    );
  }
}
