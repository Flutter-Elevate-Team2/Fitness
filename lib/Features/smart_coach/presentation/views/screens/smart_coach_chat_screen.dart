import 'dart:ui';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_history_panel.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_input_field.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_message_list.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_chat_app_bar.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The main chat screen for the Smart Coach feature.
///
/// Uses a [StatefulWidget] **only** to manage:
///  - `_isHistoryOpen` toggle for the sliding panel.
///  - [ScrollController] for auto-scroll behaviour.
///  - [TextEditingController] lifecycle (via [ChatInputField]).
class SmartCoachChatScreen extends StatefulWidget {
  const SmartCoachChatScreen({super.key});

  @override
  State<SmartCoachChatScreen> createState() => _SmartCoachChatScreenState();
}

class _SmartCoachChatScreenState extends State<SmartCoachChatScreen> {
  bool _isHistoryOpen = false;
  final ScrollController _scrollController = ScrollController();
  bool _userHasScrolledUp = false;

  void _openHistory() => setState(() => _isHistoryOpen = true);
  void _closeHistory() => setState(() => _isHistoryOpen = false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Detects if the user manually scrolled up (away from the bottom).
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final isAtBottom = _scrollController.offset <= 50;
    if (_userHasScrolledUp && isAtBottom) {
      _userHasScrolledUp = false;
    } else if (!_userHasScrolledUp && _scrollController.offset > 50) {
      _userHasScrolledUp = true;
    }
  }

  /// Smoothly scrolls to the bottom (newest message).
  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

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

          /// ── Layer 1: Main chat UI ──
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  /// Custom app bar
                  SmartCoachChatAppBar(
                    onBack: () {
                      vm.loadHistory();
                      context.pop();
                    },
                    onMenuTap: () {
                      vm.loadHistory();
                      _openHistory();
                    },
                  ),

                  /// Chat messages
                  Expanded(
                    child: BlocConsumer<SmartCoachViewModel, SmartCoachState>(
                      listenWhen: (prev, curr) =>
                          curr is SmartCoachStreaming && !_userHasScrolledUp,
                      listener: (context, state) => _scrollToBottom(),
                      buildWhen: (prev, curr) =>
                          curr is SmartCoachStreaming ||
                          curr is SmartCoachStreamDone ||
                          curr is SmartCoachError ||
                          curr is SmartCoachSafetyBlocked,
                      builder: (context, state) {
                        final messages = switch (state) {
                          SmartCoachStreaming(:final messages) => messages,
                          SmartCoachStreamDone(:final messages) => messages,
                          SmartCoachError(:final messages) => messages,
                          SmartCoachSafetyBlocked(:final messages) => messages,
                          _ => const <MessageEntity>[],
                        };

                        return ChatMessageList(
                          messages: messages,
                          scrollController: _scrollController,
                          isStreaming: vm.isStreaming,
                          onRetry: () => vm.retryLastMessage(),
                          showRetry: state is SmartCoachError,
                        );
                      },
                    ),
                  ),

                  /// Input field
                  ChatInputField(
                    enabled: !vm.isStreaming,
                    onSend: (text) {
                      final sessionId = vm.currentSessionId;
                      if (sessionId == null) return;
                      vm.sendMessage(sessionId, text);
                      _userHasScrolledUp = false;
                      _scrollToBottom();
                    },
                  ),
                ],
              ),
            ),
          ),

          /// ── Layer 2: Sliding history panel ──
          BlocBuilder<SmartCoachViewModel, SmartCoachState>(
            builder: (context, state) {
              // Read directly from the ViewModel variable instead of the state
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
