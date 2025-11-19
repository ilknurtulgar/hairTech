import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class ResultInformationContainer extends StatelessWidget {
  final String text;

  const ResultInformationContainer({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(244),
      decoration: BoxDecoration(
        color: AppColors.lightgray,
        borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(20)),
      ),
      padding: ResponsePadding.generalContainer(),
      child: SingleChildScrollView(
        child: Text(
          text,
          style: TextUtility.getStyle(
            fontSize: SizeConfig.responsiveWidth(16),
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: AppColors.darker,
          ),
        ),
      ),
    );
  }
}
