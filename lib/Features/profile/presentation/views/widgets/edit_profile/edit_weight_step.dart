import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class EditWeightStep extends StatelessWidget {
  final int selectedWeight;
  final ValueChanged<int> onWeightChanged;
  final VoidCallback onNextStep;
  final VoidCallback onBackButtonPressed;
  final bool useScaffold;

  const EditWeightStep({
    super.key,
    required this.selectedWeight,
    required this.onWeightChanged,
    required this.onNextStep,
    required this.onBackButtonPressed,
    this.useScaffold = true,
  });

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      useScaffold: useScaffold,
      onBackPressed: onBackButtonPressed,
      title: context.l10n.whatIsYourWeight,
      subtitle: context.l10n.personalizedPlanNote,
      showBackButton: true,
      buttonTitle: context.l10n.done,
      onButtonPressed: onNextStep,
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
