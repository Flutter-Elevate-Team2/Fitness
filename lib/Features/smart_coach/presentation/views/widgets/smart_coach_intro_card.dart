import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';

/// Content card inside the bottom frosted [SharedContainer] on the intro screen.
///
/// Shows the "How Can I Assist You Today?" title and a "Get Started" CTA button.
class SmartCoachIntroCard extends StatelessWidget {
  /// Fires when the user taps "Get Started".
  /// TODO: wire to Cubit navigation event.
  final VoidCallback? onGetStarted;

  const SmartCoachIntroCard({super.key, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with context.l10n equivalents
    final title = 'How Can I Assist You\nToday ?'; // TODO: context.l10n.coachAssistTitle
    final buttonLabel = 'Get Started'; // TODO: context.l10n.getStarted

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),

        /// ── Title ──
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.white,
          ),
        ),

        const SizedBox(height: 20),

        /// ── CTA Button ──
        CustomButton(
          title: buttonLabel,
          backgroundColor: AppColors.primary,
          onPressed: onGetStarted ?? () {},
        ),

        /// Extra bottom padding for safe area
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
