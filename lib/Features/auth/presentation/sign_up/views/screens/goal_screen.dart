import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  final int currentStep;
  final ValueChanged<String> onNextStep;
  final VoidCallback onBackButtonPressed;
  final bool useScaffold;

  const GoalScreen({
    super.key,
    required this.currentStep,
    required this.onNextStep,
    required this.onBackButtonPressed,
    this.useScaffold = true,
  });

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  int? selectedIndex;

  /// API-friendly goal keys (locale-independent)
  static const List<String> _goalKeys = [
    'gain_weight',
    'lose_weight',
    'get_fitter',
    'gain_more_flexible',
    'learn_the_basic',
  ];

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
      useScaffold: widget.useScaffold,
      onBackPressed: widget.onBackButtonPressed,
      title: context.l10n.whatIsYourGoal,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.next,
      onButtonPressed: selectedIndex != null
          ? () => widget.onNextStep(_goalKeys[selectedIndex!])
          : null,
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
