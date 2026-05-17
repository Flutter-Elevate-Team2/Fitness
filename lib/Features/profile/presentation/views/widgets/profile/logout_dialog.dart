import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/gen/assets.gen.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SharedContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.authLogo.image(width: 80, height: 80),
            const SizedBox(height: 24),
            Text(
              context.l10n.logout,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
               ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.logoutConfirmation,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
               ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    backgroundColor: AppColors.grayLight,
                     onPressed: () => Navigator.pop(context),
                    title: context.l10n.cancelDialog,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                     onPressed: () {
                      Navigator.pop(context);
                      context.read<ProfileViewModel>().doIntent(LogoutEvent());
                    },
                    title: context.l10n.logout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
