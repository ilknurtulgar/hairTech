import 'package:flutter/material.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class EvaluationData {
  final String label;
  final String value;
  final Color color;
  final double fontSize;

  const EvaluationData({
    required this.label,
    required this.value,
    required this.color,
    required this.fontSize,
  });
}

class EvaluationItem extends StatelessWidget {
  final List<EvaluationData> evaluations;

  const EvaluationItem({
    Key? key,
    required this.evaluations,
  }) : assert(evaluations.length == 5, 'EvaluationItem must have exactly 5 items'),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        5,
        (index) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              evaluations[index].value,
              style: TextUtility.getStyle(
                fontSize: evaluations[index].fontSize,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: evaluations[index].color,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(2)),
            Text(
              evaluations[index].label,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(10),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: evaluations[index].color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
