import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInputWidget extends StatefulWidget {
  const OtpInputWidget({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
    this.errorText,
  });

  final int length;
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final String? errorText;

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _localError;

  @override
  void initState() {
    super.initState();
    _localError = widget.errorText;
  }

  @override
  void didUpdateWidget(covariant OtpInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _localError = widget.errorText;
      });

      if (widget.errorText != null && widget.errorText!.isNotEmpty) {
        _focusNode.requestFocus();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasError = _localError != null && _localError!.isNotEmpty;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.white, width: 1.5)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
         border: Border(bottom: BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.red,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.red, width: 1.5)),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Pinput(
            controller: _controller,
            focusNode: _focusNode,
            length: widget.length,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: hasError ? errorPinTheme : focusedPinTheme,
            submittedPinTheme: hasError ? errorPinTheme : submittedPinTheme,
            errorPinTheme: errorPinTheme,
            forceErrorState: hasError,
            pinputAutovalidateMode: PinputAutovalidateMode.disabled,
            showCursor: true,
            cursor: Container(
              width: 2,
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            onChanged: (value) {
              if (_localError != null) {
                setState(() {
                  _localError = null;
                });
              }
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            onCompleted: (value) {
              widget.onCompleted(value);
            },
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                _localError!,
                style: const TextStyle(
                  color: AppColors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
