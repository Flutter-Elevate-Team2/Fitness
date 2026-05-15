import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/gender_selection_button.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';

class SignupGenderStep extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onGenderSelected;
  final VoidCallback onNextStep;
  final int currentStep;
  final VoidCallback onBackButtonPressed;

  const SignupGenderStep({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
    required this.onNextStep,
    required this.currentStep,
    required this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      onBackPressed: onBackButtonPressed,
      title: context.l10n.tellUsAboutYourself,
      subtitle: context.l10n.needToKnowGender,
      showBackButton: false,
      buttonTitle: context.l10n.next,

      /// Disable the button until a gender is selected
      onButtonPressed: selectedGender != null ? onNextStep : null,

      /// Step indicator
      stepIndicator: CustomStepProgress(currentStep: currentStep),

      /// Gender selection circles
      formBody: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GenderSelectionButton(
            label: context.l10n.male,
            imagePath: Assets.icons.male.path,
            isSelected: selectedGender == 'male',
            onTap: () => onGenderSelected('male'),
          ),
          const SizedBox(height: 24),
          GenderSelectionButton(
            label: context.l10n.female,
            imagePath: Assets.icons.female.path,
            isSelected: selectedGender == 'female',
            onTap: () => onGenderSelected('female'),
          ),
        ],
      ),
    );
  }
}
