import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';

/// Chat input field pinned at the bottom of the chat screen.
///
/// This is one of the few [StatefulWidget]s because it owns a
/// [TextEditingController] and [FocusNode] that must be disposed.
class ChatInputField extends StatefulWidget {
  /// Fires when the user taps the send button.
  /// TODO: wire to Cubit sendMessage event.
  final VoidCallback? onSend;

  /// Fires on every keystroke.
  /// TODO: wire to Cubit onTyping event.
  final ValueChanged<String>? onChanged;

  const ChatInputField({
    super.key,
    this.onSend,
    this.onChanged,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final isTyping = _controller.text.trim().isNotEmpty;
      if (isTyping != _isTyping) {
        setState(() => _isTyping = isTyping);
      }
    });
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hint = 'Type a message...'; // TODO: context.l10n.typeAMessage

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SharedContainer(
          borderRadius: 24,
          blur: 15,
          opacity: 0.25,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// ── Text field ──
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,

                  minLines: 1,
                  maxLines: 5,
                  onChanged: widget.onChanged,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTypography.labelLarge.copyWith(
                      color: AppColors.light600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 12,bottom: 12,left: 8),
                    isDense: true,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// ── Mic / Send button ──
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    widget.onSend?.call();
                    // TODO: clear after send once connected to Cubit
                  },
                  child: Icon(
                    _isTyping ? Icons.send : Icons.mic,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
