import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';


class ChatInputField extends StatefulWidget {
  /// Fires when the user taps the send button — passes the current text.
  final ValueChanged<String>? onSend;

  /// Whether the input field accepts typing (disabled during streaming).
  final bool enabled;

  const ChatInputField({
    super.key,
    this.onSend,
    this.enabled = true,
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

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;

    widget.onSend?.call(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final hint = context.l10n.smartCoachTypeMessage;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 200),
          child: SharedContainer(
            borderRadius: 24,
            blur: 15,
            opacity: 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _handleSend(),
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTypography.labelLarge.copyWith(
                        color: AppColors.light600,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        top: 12,
                        bottom: 12,
                        left: 8,
                      ),
                      isDense: true,
                    ),
                  ),
                ),

                const SizedBox(width: 8),


                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: _handleSend,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _isTyping ? Icons.send : Icons.mic,
                        key: ValueKey(_isTyping),
                        color: widget.enabled
                            ? AppColors.primary
                            : AppColors.grayLight,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
