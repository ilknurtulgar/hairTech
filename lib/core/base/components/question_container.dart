import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';
import 'button.dart';

class QuestionContainer extends StatefulWidget {
  final int questionNumber;
  final String questionText;
  final Function(bool?)? onAnswerChanged;

  const QuestionContainer({
    Key? key,
    required this.questionNumber,
    required this.questionText,
    this.onAnswerChanged,
  }) : super(key: key);

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  bool? selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = null;
  }

  void _handleAnswer(bool answer) {
    setState(() {
      selectedAnswer = answer;
    });
    if (widget.onAnswerChanged != null) {
      widget.onAnswerChanged!(answer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      padding: EdgeInsets.all(SizeConfig.responsiveWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.lightgray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.questionNumber}. ${widget.questionText}',
            style: TextUtility.getStyle(
              fontSize: SizeConfig.responsiveWidth(16),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: AppColors.darker,
            ),
          ),
          Padding(
            padding: ResponsePadding.formElements(),
          ),
          
          Row(
            children: [
              Expanded(
                child: Button(
                  text: ConstTexts.yesText,
                  backgroundColor: selectedAnswer == true
                      ? AppColors.secondary
                      : AppColors.darkgray,
                  textColor: AppColors.white,
                  onTap: () => _handleAnswer(true),
                ),
              ),
              Padding(padding: ResponsePadding.buttonSpacing()),
              Expanded(
                child: Button(
                  text: ConstTexts.noText,
                  backgroundColor: selectedAnswer == false
                      ? AppColors.secondary
                      : AppColors.darkgray,
                  textColor: AppColors.white,
                  onTap: () => _handleAnswer(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
