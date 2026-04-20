import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharedScaffold extends StatelessWidget {
  final String? backgroundImage;
  final String? foregroundImage;
  final Widget body;
  final bool showBackButton;
  final Widget? title;
  final double? foregroundImageHeight;
  final double? foregroundImageTop;
  final double appBarTopPadding;
  final VoidCallback? onBackButtonPressed;

  const SharedScaffold({
    super.key,
    this.backgroundImage,
    this.foregroundImage,
    required this.body,
    this.showBackButton = true,
    this.title,
    this.foregroundImageHeight,
    this.foregroundImageTop,
    this.appBarTopPadding = 20.0,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool hideAppBar = (title == null && !showBackButton);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.black,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // 1. Background Image
            if (backgroundImage != null)
              Positioned.fill(
                child: Image.asset(backgroundImage!, fit: BoxFit.cover),
              ),

            // 2. Foreground Image
            if (foregroundImage != null)
              Positioned(
                top:
                    foregroundImageTop ??
                    MediaQuery.of(context).size.height * 0.02,
                left: 0,
                right: 0,
                child: Image.asset(
                  foregroundImage!,
                  height:
                      foregroundImageHeight ??
                      MediaQuery.of(context).size.height * 0.7,
                  fit: BoxFit.contain,
                ),
              ),

            // 3. Main Content & Custom AppBar
            Column(
              children: [
                if (!hideAppBar)
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10,
                    ),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: [
                          if (showBackButton)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap:
                                    onBackButtonPressed ??
                                    () => Navigator.pop(context),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (title != null) Center(child: title),
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  child: body,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
