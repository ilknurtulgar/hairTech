import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppBarThemeData get appBarTheme => Theme.of(this).appBarTheme;
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  double dynamicHeight(double value) => (height - topPadding - bottomPadding) / 874 * value; //AppConst.designHeight
  double dynamicWidth(double value) => width / 402 * value; // AppConst.designWidth

  //EdgeInsets
  ///Horizontal padding with custom value
  EdgeInsets horizontal(double padding) => EdgeInsets.symmetric(horizontal: padding);
  ///Vertical padding with custom value
  EdgeInsets vertical(double padding) => EdgeInsets.symmetric(vertical: padding);
  ///Only left padding with custom value
  EdgeInsets left(double padding) => EdgeInsets.only(left: padding);
  ///Only right padding with custom value
  EdgeInsets right(double padding) => EdgeInsets.only(right: padding);
  // /Only yop padding with custom value
  EdgeInsets top(double padding) => EdgeInsets.only(top: padding);
  ///Only bottom padding with custom value
  EdgeInsets bottom(double padding) => EdgeInsets.only(bottom: padding);
  ///All padding with custom value
  EdgeInsets all(double padding) => EdgeInsets.all(padding);
}
