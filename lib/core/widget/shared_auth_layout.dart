import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class SharedAuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget formBody;
  final String buttonTitle;
  final bool showBackButton;
  final bool isGreeting;
  final VoidCallback? onButtonPressed;
  final Widget? stepIndicator;
  final Widget? underButtonWidget;
  final VoidCallback? onBackPressed;

  const SharedAuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formBody,
    required this.buttonTitle,
    required this.showBackButton,
    this.onButtonPressed,
    this.stepIndicator,
    this.underButtonWidget,
    this.isGreeting = false, this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle topStyle = isGreeting
        ? Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.normal,
          )
        : Theme.of(
            context,
          ).textTheme.headlineLarge!.copyWith(color: AppColors.white);

    final TextStyle bottomStyle = isGreeting
        ? Theme.of(
            context,
          ).textTheme.headlineLarge!.copyWith(color: AppColors.white)
        : Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.normal,
          );

   return SharedScaffold(
      showBackButton: showBackButton,
      onBackButtonPressed: onBackPressed,
      title: Image.asset(Assets.images.appIcon1.path, height: 38),
      backgroundImage: Assets.images.authBackground.path,

      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),

                if (stepIndicator != null) ...[
                  Center(child: stepIndicator!),
                  const SizedBox(height: 20),
                ],

                /// Head Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: topStyle),
                      Text(subtitle, style: bottomStyle),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                /// Container
                SharedContainer(
                  borderRadius: 50,
                  blur: 20.6,
                  opacity: .0001,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      formBody,
                      const SizedBox(height: 24),
                      CustomButton(
                        title: buttonTitle,
                        onPressed: onButtonPressed,
                        backgroundColor: AppColors.primary,
                      ),
                      if (underButtonWidget != null) ...[
                        const SizedBox(height: 16),
                        underButtonWidget!,
                      ],
                    ],
                  ),
                ),

                const Spacer(flex: 3),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
