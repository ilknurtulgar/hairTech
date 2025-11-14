import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/text_utility.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double buttonWidth;
  final double buttonHeight;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutline;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 56,
    this.backgroundColor = AppColors.dark,
    this.textColor = AppColors.light,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: TextUtility.getStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextUtility.getStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}