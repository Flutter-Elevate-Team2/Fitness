// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/BalooThambi2-Bold.ttf
  String get balooThambi2Bold => 'assets/fonts/BalooThambi2-Bold.ttf';

  /// File path: assets/fonts/BalooThambi2-ExtraBold.ttf
  String get balooThambi2ExtraBold => 'assets/fonts/BalooThambi2-ExtraBold.ttf';

  /// File path: assets/fonts/BalooThambi2-Medium.ttf
  String get balooThambi2Medium => 'assets/fonts/BalooThambi2-Medium.ttf';

  /// File path: assets/fonts/BalooThambi2-Regular.ttf
  String get balooThambi2Regular => 'assets/fonts/BalooThambi2-Regular.ttf';

  /// File path: assets/fonts/BalooThambi2-SemiBold.ttf
  String get balooThambi2SemiBold => 'assets/fonts/BalooThambi2-SemiBold.ttf';

  /// List of all assets
  List<String> get values => [
    balooThambi2Bold,
    balooThambi2ExtraBold,
    balooThambi2Medium,
    balooThambi2Regular,
    balooThambi2SemiBold,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Apple.png
  AssetGenImage get apple => const AssetGenImage('assets/icons/Apple.png');

  /// File path: assets/icons/Google.png
  AssetGenImage get google => const AssetGenImage('assets/icons/Google.png');

  /// File path: assets/icons/chat ai.png
  AssetGenImage get chatAi => const AssetGenImage('assets/icons/chat ai.png');

  /// File path: assets/icons/explore.png
  AssetGenImage get explore => const AssetGenImage('assets/icons/explore.png');

  /// File path: assets/icons/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/icons/facebook.png');

  /// File path: assets/icons/female.png
  AssetGenImage get female => const AssetGenImage('assets/icons/female.png');

  /// File path: assets/icons/male.png
  AssetGenImage get male => const AssetGenImage('assets/icons/male.png');

  /// File path: assets/icons/profile.png
  AssetGenImage get profile => const AssetGenImage('assets/icons/profile.png');

  /// File path: assets/icons/workouts.png
  AssetGenImage get workouts =>
      const AssetGenImage('assets/icons/workouts.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    apple,
    google,
    chatAi,
    explore,
    facebook,
    female,
    male,
    profile,
    workouts,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Splash.png
  AssetGenImage get splash => const AssetGenImage('assets/images/Splash.png');

  /// File path: assets/images/app_icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app_icon.png');

  /// File path: assets/images/app_icon1.png
  AssetGenImage get appIcon1 =>
      const AssetGenImage('assets/images/app_icon1.png');

  /// File path: assets/images/auth_background.png
  AssetGenImage get authBackground =>
      const AssetGenImage('assets/images/auth_background.png');

  /// File path: assets/images/auth_logo.png
  AssetGenImage get authLogo =>
      const AssetGenImage('assets/images/auth_logo.png');

  /// File path: assets/images/home_background.jpg
  AssetGenImage get homeBackground =>
      const AssetGenImage('assets/images/home_background.jpg');

  /// File path: assets/images/lock.png
  AssetGenImage get lock => const AssetGenImage('assets/images/lock.png');

  /// File path: assets/images/mail.png
  AssetGenImage get mail => const AssetGenImage('assets/images/mail.png');

  /// File path: assets/images/onboarding1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/images/onboarding1.png');

  /// File path: assets/images/onboarding2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/images/onboarding2.png');

  /// File path: assets/images/onboarding3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/images/onboarding3.png');

  /// File path: assets/images/onboarding_background.png
  AssetGenImage get onboardingBackground =>
      const AssetGenImage('assets/images/onboarding_background.png');

  /// File path: assets/images/splash_logo.png
  AssetGenImage get splashLogo =>
      const AssetGenImage('assets/images/splash_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    splash,
    appIcon,
    appIcon1,
    authBackground,
    authLogo,
    homeBackground,
    lock,
    mail,
    onboarding1,
    onboarding2,
    onboarding3,
    onboardingBackground,
    splashLogo,
  ];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
