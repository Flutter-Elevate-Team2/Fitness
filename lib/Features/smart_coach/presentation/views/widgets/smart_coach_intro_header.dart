import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:flutter/material.dart';

/// Top header row for the Smart Coach intro screen.
///
/// Shows a greeting ("Hi \<name\>, / I Am Your Smart Coach") on the left
/// and a hamburger menu icon on the right.
class SmartCoachIntroHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onMenuTap;

  const SmartCoachIntroHeader({
    super.key,
    required this.userName,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: replace with context.l10n equivalents
    final greeting = 'Hi $userName ,'; // TODO: context.l10n.hiName(userName)
    final subtitle = 'I Am Your Smart Coach'; // TODO: context.l10n.coachSubtitle

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ── Greeting texts ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  greeting,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          /// ── Menu icon ──
          GestureDetector(
            onTap: onMenuTap,
            child: const Icon(
              Icons.menu,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
