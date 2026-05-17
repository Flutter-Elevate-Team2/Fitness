import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:flutter/material.dart';


class ChatHistoryItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ChatHistoryItem({
    super.key,
    required this.title,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [

            const Icon(
              Icons.chevron_left,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 16),


            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),


            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.delete_outline,
                    color: AppColors.red,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
