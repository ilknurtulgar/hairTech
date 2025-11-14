import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/text_utility.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutline;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.width = double.infinity,
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
      width: width,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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