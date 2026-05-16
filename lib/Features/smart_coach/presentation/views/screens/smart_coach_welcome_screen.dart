import 'dart:ui';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_history_panel.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/coach_avatar_image.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_intro_card.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_intro_header.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/user_cubit/user_view_model.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';


class SmartCoachWelcomeScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SmartCoachWelcomeScreen({super.key, this.onBack});

  @override
  State<SmartCoachWelcomeScreen> createState() => _SmartCoachWelcomeScreenState();
}

class _SmartCoachWelcomeScreenState extends State<SmartCoachWelcomeScreen> {
  bool _isHistoryOpen = false;

  void _openHistory() => setState(() => _isHistoryOpen = true);
  void _closeHistory() => setState(() => _isHistoryOpen = false);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SmartCoachViewModel>();

    return SharedScaffold(
      backgroundImage: Assets.images.chatAiBackground.path,
      showBackButton: false,
      title: null,
      body: Stack(
        children: [

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.5, sigmaY: 12.5),
              child: Container(color: const Color(0x801A1A1A)),
            ),
          ),


          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: BlocBuilder<UserCubit, UserEntity?>(
                      builder: (context, user) {

                        final userName = user?.firstName ?? '';

                        return SmartCoachIntroHeader(
                          userName: userName,
                          onMenuTap: () {
                            _openHistory();
                          },
                        );
                      },
                    ),
                  ),


                  const Expanded(
                    child: CoachAvatarImage(),
                  ),


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


          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else {
                  context.pop();
                }
              },
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


          BlocBuilder<SmartCoachViewModel, SmartCoachState>(
            builder: (context, state) {
              final sessions = vm.historySessions;

              return ChatHistoryPanel(
                isOpen: _isHistoryOpen,
                onClose: _closeHistory,
                sessions: sessions,
                onSessionTap: (session) {
                  _closeHistory();
                  vm.loadSession(session.id, session.messages);
                },
                onSessionDelete: (sessionId) {
                  vm.deleteSession(sessionId);
                },
                onNewChat: () async {
                  _closeHistory();
                  await vm.createSession();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
