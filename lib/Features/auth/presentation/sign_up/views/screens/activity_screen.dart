import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  final int currentStep;
  final VoidCallback onNextStep;
  final VoidCallback onBackButtonPressed;

  const ActivityScreen({
    super.key,
    required this.currentStep,
    required this.onNextStep,
    required this.onBackButtonPressed,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<String> activities = [
      context.l10n.rookie,
      context.l10n.beginner,
      context.l10n.intermediate,
      context.l10n.advance,
      context.l10n.trueBeast,
    ];

    return SharedAuthLayout(
      onBackPressed: widget.onBackButtonPressed,
      title: context.l10n.physicalActivityLevel,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.next,
      onButtonPressed: selectedIndex != null ? widget.onNextStep : null,
      stepIndicator: CustomStepProgress(currentStep: widget.currentStep),
      formBody: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(activities.length, (index) {
          return CustomSelectionTile(
            title: activities[index],
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
