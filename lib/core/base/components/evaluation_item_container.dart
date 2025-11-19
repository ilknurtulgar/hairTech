import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import 'evaluation_item.dart';

class EvaluationItemContainer extends StatelessWidget {
  final String growthValue;
  final String densityValue;
  final String naturalnessValue;
  final String healthValue;
  final String overallValue;

  const EvaluationItemContainer({
    Key? key,
    required this.growthValue,
    required this.densityValue,
    required this.naturalnessValue,
    required this.healthValue,
    required this.overallValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(63),
      decoration: BoxDecoration(
        color: AppColors.darker,
        borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(20)),
      ),
      padding: ResponsePadding.generalContainer(),
      child: Center(
        child: EvaluationItem(
          growthValue: growthValue,
          densityValue: densityValue,
          naturalnessValue: naturalnessValue,
          healthValue: healthValue,
          overallValue: overallValue,
          valueColor: AppColors.white,
          valueFontSize: SizeConfig.responsiveWidth(16),
        ),
      ),
    );
  }
}
