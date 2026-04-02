import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class SignupWeightStep extends StatelessWidget {
  final int selectedWeight;
  final ValueChanged<int> onWeightChanged;
  final VoidCallback onNextStep;
  final int currentStep;

  const SignupWeightStep({
    super.key,
    required this.selectedWeight,
    required this.onWeightChanged,
    required this.onNextStep,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      title: context.l10n.whatIsYourWeight,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.done,
      onButtonPressed: onNextStep,
      stepIndicator: CustomStepProgress(currentStep: currentStep),
      formBody: HorizontalNumberPicker(
        minValue: 30,
        maxValue: 200,
        initialValue: selectedWeight,
        unitLabel: 'Kg',
        onChanged: onWeightChanged,
      ),
    );
  }
}
