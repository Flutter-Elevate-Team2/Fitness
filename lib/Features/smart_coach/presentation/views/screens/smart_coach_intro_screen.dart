import 'dart:ui';

import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/coach_avatar_image.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_intro_card.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_intro_header.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class SmartCoachIntroScreen extends StatelessWidget {
  /// Callback when the user taps "Get Started".
  /// TODO: wire to Cubit navigation event.
  final VoidCallback? onGetStarted;

  /// Callback when the hamburger menu is tapped.
  /// TODO: wire to Cubit or parent navigation.
  final VoidCallback? onMenuTap;

  /// Callback when the back button is tapped (returns to Explore tab).
  final VoidCallback? onBack;

  const SmartCoachIntroScreen({
    super.key,
    this.onGetStarted,
    this.onMenuTap,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      backgroundImage: Assets.images.chatAiBackground.path,
      showBackButton: false,
      title: null,
      body: Stack(
        children: [
          /// ── Blur overlay ──
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.5, sigmaY: 12.5),
              child: Container(color: const Color(0x801A1A1A)),
            ),
          ),

          /// ── Main content ──
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  /// ── Top: greeting + menu icon ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SmartCoachIntroHeader(
                      userName: 'Ahmed', // TODO: context.l10n.hiName(userName)
                      onMenuTap: onMenuTap ?? () {},
                    ),
                  ),

                  /// ── Center: 3D coach image ──
                  const Expanded(
                    child: CoachAvatarImage(),
                  ),

                  /// ── Bottom: frosted card with CTA ──
                  SharedContainer(
                    isTopOnly: true,
                    blur: 20,
                    opacity: 0.15,
                    child: SmartCoachIntroCard(
                      onGetStarted: onGetStarted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ── Back button (same style as ExerciseHeaderWidget) ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
