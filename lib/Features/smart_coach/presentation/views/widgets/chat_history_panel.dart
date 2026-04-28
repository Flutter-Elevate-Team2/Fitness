import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_history_item.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';

/// Right-side sliding history panel (NOT a Flutter Drawer).
///
/// Implemented as an overlay using [AnimatedSlide] inside the
/// chat screen's body [Stack]. A full-screen transparent barrier
/// behind the panel triggers [onClose] when tapped.
class ChatHistoryPanel extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final List<String> historyItems;

  const ChatHistoryPanel({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.historyItems,
  });

  @override
  Widget build(BuildContext context) {
    final panelTitle =
        'Previous Conversations'; // TODO: context.l10n.previousConversations

    /// Panel width = ~85 % of screen
    final panelWidth = MediaQuery.of(context).size.width * 0.85;

    return Stack(
      children: [
        /// ── Scrim / tap-outside barrier ──
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: AppColors.black.withValues(alpha: 0.4),
              ),
            ),
          ),

        /// ── Sliding panel ──
        AnimatedSlide(
          offset: isOpen ? Offset.zero : const Offset(1, 0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: panelWidth,
              height: double.infinity,
              child: SharedContainer(
                borderRadius: 0,
                blur: 20,
                opacity: 0.85,
                padding: EdgeInsets.zero,
                child: SafeArea(
                  child: Column(
                    children: [
                      /// ── Header ──
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: onClose,
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              panelTitle,
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ── Divider ──
                      const Divider(
                        color: AppColors.grayMid,
                        height: 1,
                        thickness: 0.5,
                      ),

                      /// ── History list ──
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: historyItems.length,
                          separatorBuilder: (_, _) => const Divider(
                            color: AppColors.grayMid,
                            height: 1,
                            thickness: 0.5,
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (context, index) {
                            return ChatHistoryItem(
                              title: historyItems[index],
                              onTap: () {
                                // TODO: context.read<SmartCoachCubit>().loadConversation(index)
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
