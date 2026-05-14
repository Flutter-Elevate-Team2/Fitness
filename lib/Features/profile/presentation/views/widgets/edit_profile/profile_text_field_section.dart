import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/form_validators.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_text_field.dart';

class ProfileTextFieldSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final VoidCallback onChanged;

  final String? weightText;
  final String? goalText;
  final String? activityText;

  final VoidCallback onEditWeight;
  final VoidCallback onEditGoal;
  final VoidCallback onEditActivity;

  const ProfileTextFieldSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.onChanged,
    required this.weightText,
    required this.goalText,
    required this.activityText,
    required this.onEditWeight,
    required this.onEditGoal,
    required this.onEditActivity,
  });

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(
          text: title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          children: [
            TextSpan(
              text: context.l10n.tabToEdit,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProfileField(
          label: context.l10n.firstNameLabel,
          controller: firstNameController,
          onChanged: onChanged,
          prefixIcon: Icon(Icons.person, size: 20, color: AppColors.white),
        ),
        const SizedBox(height: 16),
        CustomProfileField(
          label: context.l10n.lastNameLabel,
          controller: lastNameController,
          onChanged: onChanged,
          prefixIcon: Icon(Icons.person, size: 20, color: AppColors.white),
        ),
        const SizedBox(height: 16),
        CustomProfileField(
          label: context.l10n.emailLabel,
          controller: emailController,
          onChanged: onChanged,
          prefixIcon: Image.asset(
            Assets.images.mail.path,
            height: 20,
            color: AppColors.white,
          ),
          validator: (value) => FormValidators.validateEmail(context, value),
        ),
        const SizedBox(height: 36),
        _buildSectionHeader(context, context.l10n.yourWeight),
        const SizedBox(height: 12),
        CustomProfileField(
          readOnly: true,
          showEditHint: true,
          fillColor: AppColors.white.withValues(alpha: 0.2),
          controller: TextEditingController(text: weightText ?? ''),
          onTap: onEditWeight,
        ),
        const SizedBox(height: 16),

        _buildSectionHeader(context, context.l10n.yourGoal),
        const SizedBox(height: 12),
        CustomProfileField(
          readOnly: true,
          showEditHint: true,
          fillColor: AppColors.white.withValues(alpha: 0.2),
          controller: TextEditingController(text: goalText ?? ''),
          onTap: onEditGoal,
        ),
        const SizedBox(height: 16),

        _buildSectionHeader(context, context.l10n.yourActivityLevel),
        const SizedBox(height: 12),
        CustomProfileField(
          readOnly: true,
          showEditHint: true,
          fillColor: AppColors.white.withValues(alpha: 0.2),
          controller: TextEditingController(text: activityText ?? ''),
          onTap: onEditActivity,
        ),
      ],
    );
  }
}
