import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class SignupHeightStep extends StatelessWidget {
  final int selectedHeight;
  final ValueChanged<int> onHeightChanged;
  final VoidCallback onNextStep;
  final int currentStep;

  const SignupHeightStep({
    super.key,
    required this.selectedHeight,
    required this.onHeightChanged,
    required this.onNextStep,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      title: context.l10n.whatIsYourHeight,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.next,
      onButtonPressed: onNextStep,
      stepIndicator: CustomStepProgress(currentStep: currentStep),
      formBody: HorizontalNumberPicker(
        minValue: 100,
        maxValue: 250,
        initialValue: selectedHeight,
        unitLabel: 'CM',
        onChanged: onHeightChanged,
      ),
    );
  }
}
