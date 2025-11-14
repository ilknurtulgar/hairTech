import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;


  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

 // i added it according to the iphone 16 pro design dimensions
  static double responsiveWidth(double designWidth, {double designScreenWidth = 402}) {
    return screenWidth * (designWidth / designScreenWidth);
  }


  static double responsiveHeight(double designHeight, {double designScreenHeight = 874}) {
    return screenHeight * (designHeight / designScreenHeight);
  }
}
