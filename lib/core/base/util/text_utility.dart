import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
class TextUtility {
  TextUtility._();

  static TextStyle getStyle({
    double fontSize = 14.0,
    Color color = AppColors.black,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }

  static TextStyle get subheaderStyle {
    return getStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.italic,
      color: AppColors.black,
    );
  }

  static TextStyle get headerStyle {
    return getStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      color: AppColors.black,
    );
  }

  static TextStyle get bigHeaderStyle {
    return getStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      color: AppColors.black,
    );
  }

}