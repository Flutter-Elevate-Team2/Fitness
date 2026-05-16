import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_weight_step.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EditWeightScreen extends StatelessWidget {
  final int initialWeight;
  final ValueChanged<int> onWeightChanged;
  final VoidCallback onStepComplete;
  final VoidCallback onBackButtonPressed;

  const EditWeightScreen({
    super.key,
    required this.initialWeight,
    required this.onWeightChanged,
    required this.onStepComplete,
    required this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      backgroundImage: Assets.images.authBackground.path,
      title: Image.asset(Assets.images.appIcon1.path, height: 38),
      body: SafeArea(
        child: EditWeightStep(
          useScaffold: false,
          selectedWeight: initialWeight,
          onWeightChanged: onWeightChanged,
          onNextStep: onStepComplete,
          onBackButtonPressed: onBackButtonPressed,
        ),
      ),
    );
  }
}
