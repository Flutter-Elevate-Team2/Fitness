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
            _SocialIconButton(
              assetPath: 'assets/icons/facebook.png',
              onTap: () {
                // TODO: Facebook login
              },
            ),
            const SizedBox(width: 24),
            _SocialIconButton(
              assetPath: 'assets/icons/Google.png',
              onTap: () {
                // TODO: Google login
              },
            ),
            const SizedBox(width: 24),
            _SocialIconButton(
              assetPath: 'assets/icons/Apple.png',
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

class _SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const _SocialIconButton({
    required this.assetPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
