// File: lib/core/base/components/evaluation_bar.dart

import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

// Helper function for efficient SliderThemeData creation
SliderThemeData _buildSliderTheme(BuildContext context) {
  return SliderThemeData(
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
  );
}


class EvaluationBar extends StatefulWidget {
  final String title;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onValueChanged;
  final double? initialValue; 

  const EvaluationBar({
    Key? key,
    required this.title,
    this.minValue = 1,
    this.maxValue = 5,
    required this.onValueChanged,
    this.initialValue, 
  }) : super(key: key);

  @override
  State<EvaluationBar> createState() => _EvaluationBarState();
}

class _EvaluationBarState extends State<EvaluationBar> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    // Use initialValue if provided (which we will now guarantee is >= 1.0), otherwise default to minValue (1.0).
    // This prevents the Value 0 assertion failure.
    _currentValue = widget.initialValue ?? widget.minValue; 
    
    // Ensure the initial value is used
    if (_currentValue < widget.minValue) {
        _currentValue = widget.minValue;
    }
  }

  @override
  void didUpdateWidget(covariant EvaluationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This handles external changes (like resetting the form or initial data changing)
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != null) {
      if (widget.initialValue! >= widget.minValue && widget.initialValue! <= widget.maxValue) {
        // Only update the internal state if the external value has changed and is valid
        _currentValue = widget.initialValue!;
        // Note: We intentionally DO NOT call onValueChanged here to avoid triggering 
        // a database save when the value hasn't been dragged yet.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SliderThemeData sliderThemeData = _buildSliderTheme(context);
    
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
              '${_currentValue.round()}/${widget.maxValue.toInt()}', 
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
          data: sliderThemeData, 
          child: Slider(
            value: _currentValue,
            min: widget.minValue,
            max: widget.maxValue,
            divisions: (widget.maxValue - widget.minValue).toInt(), 
            onChanged: (value) {
              setState(() {
                // Ensure the value snaps to the discrete step and is cast to double
                _currentValue = value.roundToDouble(); 
              });
              // Inform the parent controller immediately
              widget.onValueChanged(_currentValue);
            },
          ),
        ),
      ],
    );
  }
}