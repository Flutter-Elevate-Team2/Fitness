import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/goal_screen.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EditGoal extends StatefulWidget {
  final String? initialGoal;
  final ValueChanged<String> onGoalSelected;
  final VoidCallback onBackButtonPressed;

  const EditGoal({
    super.key,
    this.initialGoal,
    required this.onGoalSelected,
    required this.onBackButtonPressed,
  });

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  String? _currentGoal;

  @override
  void initState() {
    super.initState();
    _currentGoal = widget.initialGoal;
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      showBackButton: true,
      onBackButtonPressed: widget.onBackButtonPressed,
      title: Image.asset(Assets.images.appIcon1.path, height: 38),
      backgroundImage: Assets.images.authBackground.path,
      body: SafeArea(
        child: GoalScreen(
          key: ValueKey(_currentGoal),
          currentStep: 0,
          onNextStep: (goal) {
            setState(() {
              _currentGoal = goal;
            });
            widget.onGoalSelected(goal);
            Navigator.pop(context);
          },
          onBackButtonPressed: widget.onBackButtonPressed,
          useScaffold: false,
          initialGoal: _currentGoal,
        ),
      ),
    );
  }
}
