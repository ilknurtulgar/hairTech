import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/text_utility.dart';
import '../util/size_config.dart';

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
    SizeConfig.init(context);
    final double effectiveHeight = buttonHeight == 56 ? SizeConfig.responsiveHeight(56) : buttonHeight;
    if (isOutline) {
      return TextButton(
        onPressed: isLoading ? null : onTap,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(vertical: SizeConfig.responsiveHeight(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(40)),
          ),
        ),
        child: _buildChild(),
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(40)),
          ),
          elevation: 0,
        ),
        child: _buildChild(),
      ),
    );
  }

  // 5. HELPER WIDGET TO SHOW TEXT OR SPINNER
  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: SizeConfig.responsiveWidth(24),
        height: SizeConfig.responsiveWidth(24),
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
          fontSize: SizeConfig.responsiveWidth(16),
        ),
      );
    }
  }
}