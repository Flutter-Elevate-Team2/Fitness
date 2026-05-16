import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class HorizontalNumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final String unitLabel;
  final ValueChanged<int> onChanged;

  const HorizontalNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.unitLabel,
    required this.onChanged,
  });

  @override
  State<HorizontalNumberPicker> createState() =>
      _HorizontalNumberPickerState();
}

class _HorizontalNumberPickerState extends State<HorizontalNumberPicker> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialValue - widget.minValue;
    _pageController = PageController(
      viewportFraction: 0.2,
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Text(
          widget.unitLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),


        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              widget.onChanged(widget.minValue + index);
            },
            itemCount: widget.maxValue - widget.minValue + 1,
            itemBuilder: (context, index) {
              final int distance = (index - _currentPage).abs();
              final int value = widget.minValue + index;

              // Size and opacity scale based on distance from center
              final double fontSize;
              final Color color;
              final double opacity;

              if (distance == 0) {
                fontSize = 48;
                color = AppColors.primary;
                opacity = 1.0;
              } else if (distance == 1) {
                fontSize = 32;
                color = AppColors.white;
                opacity = 0.85;
              } else if (distance == 2) {
                fontSize = 26;
                color = AppColors.white;
                opacity = 0.55;
              } else {
                fontSize = 22;
                color = AppColors.light600;
                opacity = 0.3;
              }

              return Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: opacity,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontFamily:
                            Theme.of(context).textTheme.bodyMedium?.fontFamily,
                      ),
                      child: Text('$value'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),


        const Icon(
          Icons.arrow_drop_up,
          color: AppColors.primary,
          size: 36,
        ),
      ],
    );
  }
}
