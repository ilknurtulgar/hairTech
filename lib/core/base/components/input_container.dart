import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import '../util/app_colors.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class InputContainer extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const InputContainer({
    Key? key,
    this.controller,
    this.hintText,
    this.maxLines = 5,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(188),
      padding: ResponsePadding.generalContainerLarge(),
      decoration: BoxDecoration(
        color: AppColors.lightgray,
        borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(20)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        style: TextUtility.getStyle(
          fontSize: SizeConfig.responsiveWidth(16),
          fontWeight: FontWeight.w400,
          color: AppColors.darker,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextUtility.getStyle(
            fontSize: SizeConfig.responsiveWidth(16),
            fontWeight: FontWeight.w400,
            color: AppColors.darkgray,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
