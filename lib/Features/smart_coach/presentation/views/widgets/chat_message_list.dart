import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/coach_message_bubble.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/user_message_bubble.dart';
import 'package:flutter/material.dart';

/// Simple data class representing a single chat message.
class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});
}

/// Scrollable list of chat message bubbles.
///
/// Uses `reverse: true` so the newest messages appear at the bottom
/// and the list auto-scrolls to the latest entry.
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dummy messages for static layout.
    /// TODO: replace with Cubit state messages.
    final messages = <ChatMessage>[
      const ChatMessage(
        text: 'Hello How Can I Assist You Today ?',
        isUser: false,
      ),
      const ChatMessage(
        text: 'Lorem Ipsum Dolor Sit Amet Consectetur.',
        isUser: true,
      ),
      const ChatMessage(
        text: 'Hello How Can I Assist You Today ?',
        isUser: false,
      ),
      const ChatMessage(
        text: 'Lorem Ipsum Dolor Sit Amet Consectetur.',
        isUser: true,
      ),
    ];

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        /// Because reverse is true, index 0 = last message in the list.
        final message = messages[messages.length - 1 - index];

        if (message.isUser) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: UserMessageBubble(message: message.text),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CoachMessageBubble(message: message.text),
        );
      },
    );
  }
}
