import 'package:flutter/material.dart';
import '../util/const_texts.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class EvaluationItem extends StatelessWidget {
  final String growthValue;
  final String densityValue;
  final String naturalnessValue;
  final String healthValue;
  final String overallValue;
  final Color valueColor;
  final double valueFontSize;

  const EvaluationItem({
    Key? key,
    required this.growthValue,
    required this.densityValue,
    required this.naturalnessValue,
    required this.healthValue,
    required this.overallValue,
    required this.valueColor,
    required this.valueFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = [
      EvaluationTexts.evaluationGrowthLabel,
      EvaluationTexts.evaluationDensityLabel,
      EvaluationTexts.evaluationNaturalnessLabel,
      EvaluationTexts.evaluationHealthLabel,
      EvaluationTexts.evaluationOverallLabel,
    ];
    
    final values = [growthValue, densityValue, naturalnessValue, healthValue, overallValue];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        5,
        (index) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              values[index],
              style: TextUtility.getStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: valueColor,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(2)),
            Text(
              labels[index],
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(10),
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
