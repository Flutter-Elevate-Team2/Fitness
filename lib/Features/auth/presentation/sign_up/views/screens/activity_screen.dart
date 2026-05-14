import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  final int currentStep;
  final ValueChanged<String> onNextStep;
  final VoidCallback onBackButtonPressed;
  final bool useScaffold;
  final String? initialActivity;

  const ActivityScreen({
    super.key,
    required this.currentStep,
    required this.onNextStep,
    required this.onBackButtonPressed,
    this.useScaffold = true,
    this.initialActivity,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int? selectedIndex;

  static const List<String> _activityKeys = [
    'level1',
    'level2',
    'level3',
    'level4',
    'level5',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialActivity != null &&
        _activityKeys.contains(widget.initialActivity)) {
      selectedIndex = _activityKeys.indexOf(widget.initialActivity!);
    }
  }

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
      useScaffold: widget.useScaffold,
      onBackPressed: widget.onBackButtonPressed,
      title: context.l10n.physicalActivityLevel,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.next,
      onButtonPressed: selectedIndex != null
          ? () => widget.onNextStep(_activityKeys[selectedIndex!])
          : null,
      stepIndicator: widget.currentStep > 0
          ? CustomStepProgress(currentStep: widget.currentStep)
          : null,
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
