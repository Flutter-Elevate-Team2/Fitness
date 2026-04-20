import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class SignupAgeStep extends StatelessWidget {
  final int selectedAge;
  final ValueChanged<int> onAgeChanged;
  final VoidCallback onNextStep;
  final int currentStep;
  final VoidCallback onBackButtonPressed;
  final bool useScaffold;

  const SignupAgeStep({
    super.key,
    required this.selectedAge,
    required this.onAgeChanged,
    required this.onNextStep,
    required this.currentStep,
    required this.onBackButtonPressed,
    this.useScaffold = true,
  });

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      useScaffold: useScaffold,
      onBackPressed: onBackButtonPressed,
      title: context.l10n.howOldAreYou,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.next,
      onButtonPressed: onNextStep,
      stepIndicator: CustomStepProgress(currentStep: currentStep),
      formBody: HorizontalNumberPicker(
        minValue: 14,
        maxValue: 100,
        initialValue: selectedAge,
        unitLabel: 'Year',
        onChanged: onAgeChanged,
      ),
    );
  }
}
