import 'package:flutter/material.dart';
import 'package:hairtech/core/base/components/button.dart';
import 'package:hairtech/core/base/components/result_information_container.dart'; // Assuming this path
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/views/get_started_view.dart';
import 'package:hairtech/views/patient_signup_view.dart'; // To navigate back

class QuestionsResultView extends StatelessWidget {
  // In a real app, you'd pass the analysis result here
  // final String analysisResult;
  const QuestionsResultView({
    super.key,
    // required this.analysisResult
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          ConstTexts.resultHeader,
          style: TextUtility.getStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: ResponsePadding.page(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              ConstTexts.resultTitle,
              style: TextUtility.headerStyle, // Big 32px header
            ),
            const SizedBox(height: 16),

            // Your existing component
            ResultInformationContainer(
              text: ConstTexts.resultPlaceholder, // Pass in placeholder text
            ),

            const Expanded(child: SizedBox()), // Pushes buttons to bottom

            // Randevu Al button
            Button(
              text: ConstTexts.resultButtonAppointment,
              onTap: () {
                print("Randevu Al tapped");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PatientSignUpView(),
                  ),
                );
              },
              backgroundColor: AppColors.green,
              textColor: AppColors.white,
            ),
            const SizedBox(height: 16),

            // Tanıtıma Dön button
            Button(
              text: ConstTexts.resultButtonBack,
              onTap: () {
                // Pop back to the Get Started view
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              isOutline: true,
              textColor: AppColors.darkgray,
            ),
            const SizedBox(height: 16), // Padding for bottom
          ],
        ),
      ),
    );
  }
}