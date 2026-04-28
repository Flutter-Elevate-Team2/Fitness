import 'dart:ui';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/coach_avatar_image.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_intro_card.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_intro_header.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Welcome / intro screen shown when the user has no active chat session.
///
/// Displays the coach avatar, greeting, and a "Get Started" CTA.
/// Tapping CTA creates a new session and transitions to the chat screen.
class SmartCoachWelcomeScreen extends StatelessWidget {
  const SmartCoachWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SmartCoachViewModel>();

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
                      userName: 'Ahmed',
                      onMenuTap: () {
                        // Open history panel if sessions exist
                        if (vm.historySessions.isNotEmpty) {
                          // TODO: Navigate to chat screen and open history panel
                          // context.pushNamed(Routes.smartCoachChatName);
                        }
                      },
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
                      onGetStarted: () async {
                        await vm.createSession();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ── Back button ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
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
