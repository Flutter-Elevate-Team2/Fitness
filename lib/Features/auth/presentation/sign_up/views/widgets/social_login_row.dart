import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_icon_button.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ── "Or" Divider ──
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.light600, thickness: 0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n.or,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.light600,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.light600, thickness: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// ── Social Icons Row ──
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIconButton(
              assetPath: Assets.icons.facebook.path,
              onTap: () {
                // TODO: Facebook login
              },
            ),
            const SizedBox(width: 24),
            SocialIconButton(
              assetPath: Assets.icons.google.path,
              onTap: () {
                // TODO: Google login
              },
            ),
            const SizedBox(width: 24),
            SocialIconButton(
              assetPath: Assets.icons.apple.path,
              onTap: () {
                // TODO: Apple login
              },
            ),
          ],
        ),
      ],
    );
  }
}


