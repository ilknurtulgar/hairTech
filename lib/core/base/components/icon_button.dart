import 'package:flutter/material.dart';
import '../util/size_config.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final VoidCallback onTap;
  final bool isCircle;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.iconColor,
    required this.backgroundColor,
    required this.size,
    required this.isCircle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: SizeConfig.responsiveWidth(size),
        height: SizeConfig.responsiveHeight(size),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            isCircle ? size / 2 : SizeConfig.responsiveWidth(20),
          ),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: SizeConfig.responsiveWidth(size * 0.5),
        ),
      ),
    );
  }
}
