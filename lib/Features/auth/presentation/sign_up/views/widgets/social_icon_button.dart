import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const SocialIconButton({super.key, required this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,

        padding: const EdgeInsets.all(10),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
