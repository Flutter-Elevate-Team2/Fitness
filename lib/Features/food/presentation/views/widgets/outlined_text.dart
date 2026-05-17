import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color outlineColor;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;


  const OutlinedText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.textColor = Colors.white,
    this.outlineColor = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Stroke
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = outlineColor,
          ),
        ),

        /// Fill
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}