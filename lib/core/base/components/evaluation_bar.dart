import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class EvaluationBar extends StatefulWidget {
  final String title;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onValueChanged;

  const EvaluationBar({
    Key? key,
    required this.title,
    this.minValue = 1,
    this.maxValue = 5,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<EvaluationBar> createState() => _EvaluationBarState();
}

class _EvaluationBarState extends State<EvaluationBar> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.minValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(18),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: AppColors.darker,
              ),
            ),
            Text(
              '${_currentValue.toInt()}/${widget.maxValue.toInt()}',
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(18),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.responsiveHeight(10)),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: SizeConfig.responsiveHeight(4),
            activeTrackColor: AppColors.secondary,
            inactiveTrackColor: AppColors.lightgray,
            thumbColor: AppColors.secondary,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: SizeConfig.responsiveWidth(10),
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: SizeConfig.responsiveWidth(20),
            ),
            tickMarkShape: const RoundSliderTickMarkShape(
              tickMarkRadius: 0,
            ),
          ),
          child: Slider(
            value: _currentValue,
            min: widget.minValue,
            max: widget.maxValue,
            divisions: (widget.maxValue - widget.minValue).toInt(),
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
              widget.onValueChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
