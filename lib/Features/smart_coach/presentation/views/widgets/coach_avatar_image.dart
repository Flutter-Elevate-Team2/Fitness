import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Displays the 3D coach / robot image centered on screen
/// with a subtle glow effect beneath it.
class CoachAvatarImage extends StatelessWidget {
  final double? height;

  const CoachAvatarImage({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    final imageHeight = height ?? MediaQuery.of(context).size.height * 0.45;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          /// Subtle radial glow behind the robot
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.06),
              blurRadius: 80,
              spreadRadius: 20,
            ),
          ],
        ),
        child: Image.asset(
          Assets.images.robot.path,
          height: imageHeight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
