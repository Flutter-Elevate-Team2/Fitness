import 'dart:ui';

import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_history_panel.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_input_field.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_message_list.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/smart_coach_chat_app_bar.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The main chat screen for the Smart Coach feature.
///
/// Uses a [StatefulWidget] **only** to manage the purely-UI
/// `isHistoryOpen` boolean for the sliding history panel.
class SmartCoachChatScreen extends StatefulWidget {
  const SmartCoachChatScreen({super.key});

  @override
  State<SmartCoachChatScreen> createState() => _SmartCoachChatScreenState();
}

class _SmartCoachChatScreenState extends State<SmartCoachChatScreen> {
  bool _isHistoryOpen = false;

  void _openHistory() => setState(() => _isHistoryOpen = true);
  void _closeHistory() => setState(() => _isHistoryOpen = false);

  @override
  Widget build(BuildContext context) {
    /// Dummy history items for the panel.
    final historyItems = List.generate(
      5,
      (_) => 'Lorem ipsum dolor sit amet', // TODO: context.l10n.historyPreview
    );

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

          /// ── Layer 1: Main chat UI ──
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  /// Custom app bar
                  SmartCoachChatAppBar(
                    onBack: () => context.pop(),
                    onMenuTap: _openHistory,
                  ),
            
                  /// Chat messages
                  const Expanded(
                    child: ChatMessageList(),
                  ),
            
                  /// Input field
                  ChatInputField(
                    onSend: () {
                      // TODO: context.read<SmartCoachCubit>().sendMessage(text)
                    },
                    onChanged: (value) {
                      // TODO: context.read<SmartCoachCubit>().onTyping(value)
                    },
                  ),
                ],
              ),
            ),
          ),

          /// ── Layer 2: Sliding history panel ──
          ChatHistoryPanel(
            isOpen: _isHistoryOpen,
            onClose: _closeHistory,
            historyItems: historyItems,
          ),
        ],
      ),
    );
  }
}
