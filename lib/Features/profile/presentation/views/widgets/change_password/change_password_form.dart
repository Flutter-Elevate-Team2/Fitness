import 'package:fitness_app/Features/auth/presentation/login/views/widgets/password_field.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatelessWidget {
   final TextEditingController oldPasswordController;
   final TextEditingController newPasswordController;
   final TextEditingController confirmPasswordController;


  const ChangePasswordForm({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,

  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// Old Password Field
        PasswordField(controller: oldPasswordController, onChanged: () {} , title: context.l10n.oldPassword,),
        const SizedBox(height: 16),

        /// new Password Field
        PasswordField(controller: newPasswordController, onChanged: () {} , title: context.l10n.newPassword,),
        const SizedBox(height: 16),

        /// confirm Password Field
        PasswordField(controller: confirmPasswordController, onChanged: () {} , title: context.l10n.confirmPassword,),

      ],
    );
  }
}
