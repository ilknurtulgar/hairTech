import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';
import 'button.dart';

class QuestionContainer extends StatefulWidget {
  final int questionNumber;
  final String questionText;
  // --- 1. CHANGED TO ACCEPT A LIST OF STRINGS ---
  final List<String> answerChoices;
  // --- 2. CHANGED TO RETURN THE SELECTED STRING ---
  final Function(String)? onAnswerChanged;

  const QuestionContainer({
    Key? key,
    required this.questionNumber,
    required this.questionText,
    required this.answerChoices, // <-- Make it required
    this.onAnswerChanged,
  }) : super(key: key);

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  // --- 3. CHANGED STATE TO HOLD THE SELECTED STRING ---
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = null;
  }

  // --- 4. CHANGED HANDLER TO ACCEPT A STRING ---
  void _handleAnswer(String answer) {
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
        borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(20)),
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
          
          // --- 5. REPLACED Row WITH A DYNAMIC Wrap ---
          // Wrap will automatically move buttons to the next
          // line if they don't fit
          Wrap(
            spacing: ResponsePadding.buttonSpacing().horizontal, // Horizontal space
            runSpacing: ResponsePadding.formElements().vertical / 3, // Vertical space
            children: widget.answerChoices.map((choice) {
              final isSelected = selectedAnswer == choice;
              
              // We use a custom Button for 2 choices, but if
              // there are 3 or more, we might want a smaller button.
              // For now, we'll use your existing Button component.
              // If there are more than 2, we use half-width.
              final double buttonWidth = widget.answerChoices.length > 2
                  ? (SizeConfig.responsiveWidth(348) / 2) -
                      (ResponsePadding.buttonSpacing().horizontal * 2)
                  : double.infinity;

              return Button(
                text: choice,
                buttonWidth: buttonWidth, // Use calculated width
                backgroundColor:
                    isSelected ? AppColors.secondary : AppColors.darkgray,
                textColor: AppColors.white,
                onTap: () => _handleAnswer(choice),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}