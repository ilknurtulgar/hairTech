import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class PatientInformationContainer extends StatelessWidget {
  final String analysisResult;
  final String age;
  final String stage;

  const PatientInformationContainer({
    Key? key,
    required this.analysisResult,
    required this.age,
    required this.stage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(112),
      decoration: BoxDecoration(
        color: AppColors.lightgray,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: ResponsePadding.generalContainer(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Analiz Sonucu
          Row(
            children: [
              Text(
                ConstTexts.analysisResultLabel,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
              ),
              Expanded(
                child: Text(
                  analysisResult,
                  style: TextUtility.getStyle(
                    fontSize: SizeConfig.responsiveWidth(18),
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: AppColors.darker,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          // Yaş
          Row(
            children: [
              Text(
                ConstTexts.ageLabel,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
              ),
              Text(
                age,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
              ),
            ],
          ),

          // Aşama
          Row(
            children: [
              Text(
                ConstTexts.stageLabel,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
              ),
              Text(
                stage,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
