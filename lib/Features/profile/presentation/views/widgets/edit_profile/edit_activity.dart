import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/activity_screen.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EditActivity extends StatefulWidget {
  final String? initialActivity;
  final ValueChanged<String> onActivitySelected;
  final VoidCallback onBackButtonPressed;

  const EditActivity({
    super.key,
    this.initialActivity,
    required this.onActivitySelected,
    required this.onBackButtonPressed,
  });

  @override
  State<EditActivity> createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      showBackButton: true,
      onBackButtonPressed: widget.onBackButtonPressed,
      title: Image.asset(Assets.images.appIcon1.path, height: 38),
      backgroundImage: Assets.images.authBackground.path,
      body: SafeArea(
        child: ActivityScreen(
          currentStep: 0,
          onNextStep: (activity) {
            widget.onActivitySelected(activity);
            Navigator.pop(context);
          },
          onBackButtonPressed: widget.onBackButtonPressed,
          useScaffold: false,
          initialActivity: widget.initialActivity,
        ),
      ),
    );
  }
}
