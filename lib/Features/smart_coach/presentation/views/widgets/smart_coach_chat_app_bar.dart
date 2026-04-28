import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:flutter/material.dart';

/// Custom app-bar row for the Smart Coach chat screen.
///
/// Left: iOS-style back arrow.
/// Center: "Smart Coach" title.
/// Right: hamburger menu icon to open the history panel.
class SmartCoachChatAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onMenuTap;

  const SmartCoachChatAppBar({
    super.key,
    required this.onBack,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = 'Smart Coach'; // TODO: context.l10n.smartCoachTitle

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          /// ── Back button (primary circle, matching SharedScaffold style) ──
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: AppColors.white,
              ),
            ),
          ),

          /// ── Title (centered via Expanded + textAlign) ──
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.white,
              ),
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
