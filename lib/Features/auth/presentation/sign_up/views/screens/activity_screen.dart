import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/shared_text_item.dart';
import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/core/extension/context_extention.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<String> activities = [
      context.l10n.rookie,
      context.l10n.beginner,
      context.l10n.intermediate,
      context.l10n.advance,
      context.l10n.trueBeast,
    ];

    return SharedScaffold(
      backgroundImage: AppAssets.authBackground,
      title: Image.asset(AppAssets.authLogo),
      appBarTopPadding: 24.0,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            const CustomStepProgress(currentStep: 6),
            const SizedBox(height: 16),
            SharedTextItem(title: context.l10n.physicalActivityLevel),
            const SizedBox(height: 16),
            SharedContainer(
              isTopOnly: false,
              borderRadius: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(activities.length, (index) {
                    return CustomSelectionTile(
                      title: activities[index],
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = (selectedIndex == index)
                              ? null
                              : index;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  CustomButton(
                    title: context.l10n.next,
                    onPressed: selectedIndex != null ? () {} : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
