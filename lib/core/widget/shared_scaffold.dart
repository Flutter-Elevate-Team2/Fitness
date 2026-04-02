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
    final double finalForegroundHeight =
        foregroundImageHeight ?? MediaQuery.of(context).size.height * 0.7;
    final double finalTop =
        foregroundImageTop ?? MediaQuery.of(context).size.height * 0.02;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.black,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            if (backgroundImage != null)
              Positioned.fill(
                child: Image.asset(backgroundImage!, fit: BoxFit.cover),
              ),

            if (foregroundImage != null)
              Positioned(
                top: finalTop,
                left: 0,
                right: 0,
                child: Image.asset(
                  foregroundImage!,
                  height: finalForegroundHeight,
                  fit: BoxFit.contain,
                ),
              ),

            hideAppBar
                ? SafeArea(child: body)
                : NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverPadding(
                          padding: EdgeInsets.only(top: appBarTopPadding),
                          sliver: SliverAppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            centerTitle: true,
                            title: title,
                            automaticallyImplyLeading: false,

                            floating: true,
                            pinned: false,
                            snap: true,

                            leading: showBackButton
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: onBackButtonPressed ??
                                            () => Navigator.pop(context),
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
                        ),
                      ];
                    },
                    body: body,
                  ),
          ],
        ),
      ),
    );
  }
}
