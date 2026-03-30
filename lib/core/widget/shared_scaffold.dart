import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SharedScaffold extends StatelessWidget {
  final String? backgroundImage;
  final String? foregroundImage;
  final Widget body;
  final bool showBackButton;
  final Widget? title;

  const SharedScaffold({
    super.key,
    this.backgroundImage,
    this.foregroundImage,
    required this.body,
    this.showBackButton = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: title,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_left_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: Stack(
        children: [
          if (backgroundImage != null)
            Positioned.fill(
              child: Image.asset(backgroundImage!, fit: BoxFit.cover),
            ),

          if (foregroundImage != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 0,
              right: 0,
              child: Image.asset(
                foregroundImage!,
                height: MediaQuery.of(context).size.height * 0.6,
                fit: BoxFit.contain,
              ),
            ),

          SafeArea(child: body),
        ],
      ),
    );
  }
}
