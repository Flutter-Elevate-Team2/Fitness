import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateButtonSection extends StatelessWidget {
  final bool isButtonEnabled;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressed;

  const UpdateButtonSection({
    super.key,
    required this.isButtonEnabled,
    required this.formKey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileViewModel, EditProfileStates>(
      builder: (context, state) {
        final isLoading = state.editProfileState?.isLoading ?? false;

        return CustomButton(
          title: isLoading ? '' : context.l10n.update,
          onPressed: isButtonEnabled && !isLoading
              ? () {
                  if (formKey.currentState!.validate()) {
                    onPressed();
                  }
                }
              : null,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.grayLight,
        );
      },
    );
  }
}
