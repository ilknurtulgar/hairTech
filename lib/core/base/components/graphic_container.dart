import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../util/app_colors.dart';
import '../util/const_texts.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

enum EvaluationType { growth, density, naturalness, health, overall }

class GraphicContainer extends StatefulWidget {
  final Map<String, Map<EvaluationType, double>> data;

  const GraphicContainer({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<GraphicContainer> createState() => _GraphicContainerState();
}

class _GraphicContainerState extends State<GraphicContainer> {
  EvaluationType _selectedType = EvaluationType.growth;

  String _getLabel(EvaluationType type) {
    switch (type) {
      case EvaluationType.growth:
        return EvaluationTexts.evaluationGrowthLabel;
      case EvaluationType.density:
        return EvaluationTexts.evaluationDensityLabel;
      case EvaluationType.naturalness:
        return EvaluationTexts.evaluationNaturalnessLabel;
      case EvaluationType.health:
        return EvaluationTexts.evaluationHealthLabel;
      case EvaluationType.overall:
        return EvaluationTexts.evaluationOverallLabel;
    }
  }

  List<FlSpot> _getChartData() {
    final dates = widget.data.keys.toList();
    return List.generate(dates.length, (index) {
      final value = widget.data[dates[index]]?[_selectedType] ?? 0;
      return FlSpot(index.toDouble(), value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dates = widget.data.keys.toList();

    return Column(
      children: [
        Container(
          width: SizeConfig.responsiveWidth(348),
          height: SizeConfig.responsiveHeight(250),
          padding: EdgeInsets.all(SizeConfig.responsiveWidth(15)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 5,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.lightBlue,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: AppColors.lightBlue,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextUtility.getStyle(
                          fontSize: SizeConfig.responsiveWidth(12),
                          color: AppColors.darker,
                        ),
                      );
                    },
                    reservedSize: SizeConfig.responsiveWidth(30),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < dates.length) {
                        return Text(
                          dates[value.toInt()],
                          style: TextUtility.getStyle(
                            fontSize: SizeConfig.responsiveWidth(10),
                            color: AppColors.darker,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: SizeConfig.responsiveHeight(30),
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppColors.darker, width: 2),
                  bottom: BorderSide(color: AppColors.darker, width: 2),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _getChartData(),
                  isCurved: true,
                  color: AppColors.secondary,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: SizeConfig.responsiveHeight(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: EvaluationType.values.map((type) {
            final isSelected = _selectedType == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = type;
                });
              },
              child: Container(
                width: SizeConfig.responsiveWidth(60),
                height: SizeConfig.responsiveHeight(30),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : AppColors.darkgray,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  _getLabel(type),
                  style: TextUtility.getStyle(
                    fontSize: SizeConfig.responsiveWidth(12),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
