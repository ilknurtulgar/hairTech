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
  final bool isLoading; // <-- 1. ADDED isLoading PROPERTY

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 56,
    this.backgroundColor = AppColors.dark,
    this.textColor = AppColors.light,
    this.isOutline = false,
    this.isLoading = false, // <-- 2. SET DEFAULT TO false
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      return TextButton(
        // 3. DISABLE onPressed IF LOADING
        onPressed: isLoading ? null : onTap,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _buildChild(), // <-- 4. MOVED CHILD TO A HELPER
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        // 3. DISABLE onPressed IF LOADING
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
        ),
        child: _buildChild(), // <-- 4. MOVED CHILD TO A HELPER
      ),
    );
  }

  // 5. HELPER WIDGET TO SHOW TEXT OR SPINNER
  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: 24, // Standard spinner size
        height: 24,
        child: CircularProgressIndicator(
          color: textColor,
          strokeWidth: 2.5,
        ),
      );
    } else {
      return Text(
        text,
        style: TextUtility.getStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );
    }
  }
}