import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/button.dart';
import 'package:hairtech/core/base/components/result_information_container.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/views/get_started_view.dart';
import 'package:hairtech/views/patient_signup_view.dart';

class QuestionsResultView extends StatelessWidget {
  const QuestionsResultView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
      SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.darker),
          onPressed: () => Get.back(),
        ),
        title: Text(
          ConstTexts.resultHeader,
          style: TextUtility.getStyle(
            color: AppColors.darker,
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.responsiveWidth(20),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: ResponsePadding.page(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: SizeConfig.responsiveHeight(24)),
              Text(
                ConstTexts.resultTitle,
                style: TextUtility.headerStyle, // Big 32px header
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              const ResultInformationContainer(
                text: ConstTexts.resultPlaceholder, // Pass in placeholder text
              ),
              const Expanded(child: SizedBox()), // Pushes buttons to bottom
              Button(
                text: ConstTexts.resultButtonAppointment,
                onTap: () {
                  Get.to(() => const PatientSignUpView());
                  print("Randevu Al tapped");
                },
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              Button(
                text: ConstTexts.resultButtonBack,
                onTap: () {
                  // Pop back to the Get Started view
                  Get.offAll(() => const GetStartedView());
                },
                isOutline: true,
                textColor: AppColors.darkgray,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)), // Padding for bottom
            ],
          ),
        ),
      ),
    );
  }
}