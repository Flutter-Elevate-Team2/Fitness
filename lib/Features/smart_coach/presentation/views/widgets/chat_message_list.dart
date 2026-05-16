import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/coach_message_bubble.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/user_message_bubble.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';


class ChatMessageList extends StatelessWidget {
  final List<MessageEntity> messages;
  final ScrollController scrollController;
  final bool isStreaming;
  final VoidCallback? onRetry;
  final bool showRetry;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    this.isStreaming = false,
    this.onRetry,
    this.showRetry = false,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                Assets.images.robot.path,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.smartCoachEmptyChat,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.smartCoachEmptyChatSubtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.light400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];


              if (!message.isUser && message.content.isEmpty && isStreaming) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _TypingIndicator(),
                );
              }

              if (message.isUser) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: UserMessageBubble(message: message.content),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CoachMessageBubble(
                  message: message.content,
                  isPartial: message.isPartial,
                ),
              );
            },
          ),
        ),


        if (showRetry)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              label: Text(
                context.l10n.smartCoachRetryButton,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}


class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(width: 44),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.grayMid.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {

                  final phase = (_controller.value + (i * 0.33)) % 1.0;
                  final opacity = (0.3 + 0.7 * _pulse(phase)).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.light500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }


  static double _pulse(double t) {
    return (1 + _sin(t * 2 * 3.14159265)) / 2;
  }

  static double _sin(double x) {

    x = x % (2 * 3.14159265);
    if (x > 3.14159265) x -= 2 * 3.14159265;
    final x3 = x * x * x;
    final x5 = x3 * x * x;
    return x - x3 / 6 + x5 / 120;
  }
}
