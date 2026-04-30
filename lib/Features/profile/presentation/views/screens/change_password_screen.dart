import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_body.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_shimmer.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordViewModel, ChangePasswordStates>(
      listenWhen: (previous, current) =>
      previous.changePasswordState != current.changePasswordState,
      listener: (context, state) {
        final changePassState = state.changePasswordState;

         if (changePassState?.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.passwordChangedSuccess),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.of(context).pop();
        }

        if (changePassState?.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(changePassState!.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
      previous.changePasswordState != current.changePasswordState,
      builder: (context, state) {
        final changePassState = state.changePasswordState;

         if (changePassState?.isLoading == true) {
          return const ChangePasswordShimmer();
         }
      return ChangePasswordBody();
      },
    );
  }
}

