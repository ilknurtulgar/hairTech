import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/button.dart';
import 'package:hairtech/core/base/components/question_container.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'questions_result_view.dart';

class QuestionnaireView extends StatefulWidget {
  const QuestionnaireView({super.key});

  @override
  State<QuestionnaireView> createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView> {
  // A map to store the answers. The key is the question number.
  final Map<int, String> _answers = {};
  String? _errorMessage;

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    // Check if all 9 questions are answered
    if (_answers.length < 9) {
      setState(() {
        _errorMessage = ConstTexts.questionViewError;
      });
      return;
    }

    print("Submitting answers:");
    print(_answers);


    Get.to(() => const QuestionsResultView());
  }

  @override
  Widget build(BuildContext context) {
      SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
        title: Text(
          ConstTexts.questionViewHeader,
          style: TextUtility.getStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.responsiveWidth(20),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsePadding.page(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuestionContainer(
                questionNumber: 1,
                questionText: ConstTexts.questionViewQ1,
                answerChoices: ConstTexts.yesNoList,
                onAnswerChanged: (answer) => _answers[1] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 2,
                questionText: ConstTexts.questionViewQ2,
                answerChoices: ConstTexts.yesNoList,
                onAnswerChanged: (answer) => _answers[2] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 3,
                questionText: ConstTexts.questionViewQ3,
                answerChoices: ConstTexts.yesNoList,
                onAnswerChanged: (answer) => _answers[3] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 4,
                questionText: ConstTexts.questionViewQ4,
                answerChoices: ConstTexts.yesNoList,
                onAnswerChanged: (answer) => _answers[4] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 5,
                questionText: ConstTexts.questionViewQ5,
                answerChoices: ConstTexts.yesNoList,
                onAnswerChanged: (answer) => _answers[5] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 6,
                questionText: ConstTexts.questionViewQ6,
                answerChoices: ConstTexts.stressList,
                onAnswerChanged: (answer) => _answers[6] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 7,
                questionText: ConstTexts.questionViewQ7,
                answerChoices: ConstTexts.ageList,
                onAnswerChanged: (answer) => _answers[7] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 8,
                questionText: ConstTexts.questionViewQ8,
                answerChoices: ConstTexts.yesNoList,
                onAnswerChanged: (answer) => _answers[8] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              QuestionContainer(
                questionNumber: 9,
                questionText: ConstTexts.questionViewQ9,
                answerChoices: ConstTexts.yesNoList,
                onAnswerChanged: (answer) => _answers[9] = answer,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(24)),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.responsiveHeight(16)),
                  child: Text(
                    _errorMessage!,
                    style: TextUtility.getStyle(
                        color: AppColors.secondary, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              Button(
                text: ConstTexts.questionViewSubmit,
                onTap: _handleSubmit,
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(24)),
            ],
          ),
        ),
      ),
    );
  }
}