import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileSettingsTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool isLast;
  final bool isLanguage;
  final bool switchValue;
  final Function(bool)? onSwitchChanged;



  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLast = false,
    this.isLanguage = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String language = isArabic ? context.l10n.arabic : context.l10n.english;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Image.asset(icon, width: 20, height: 20),
                SizedBox(width: 16),
                Expanded(
                  child: isLanguage
                      ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$title (",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        TextSpan(
                          text: language,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        TextSpan(
                          text: ")",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                isLanguage
                ? Switch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  activeThumbColor: AppColors.white,
                  activeTrackColor:   AppColors.primary,
                  inactiveThumbColor: AppColors.white,
                  inactiveTrackColor: AppColors.grayLight,
                )
                    :
                Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                      )
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: AppColors.grayLight,
          ),
      ],
    );
  }
}
