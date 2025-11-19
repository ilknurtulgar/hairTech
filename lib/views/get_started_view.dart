import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/base/components/button.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/text_utility.dart';
import 'patient_login_view.dart';
import 'doctor_login_view.dart';
import 'questions_view.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/size_config.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.responsiveWidth(32),
              vertical: SizeConfig.responsiveHeight(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  ImageUtility.logoDark,
                  height: SizeConfig.responsiveHeight(80),
                ),
                SizedBox(height: SizeConfig.responsiveHeight(48)),
                Text(
                  ConstTexts.getStartedHeader,
                  style: TextUtility.headerStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.responsiveHeight(32)),
                Button(
                  text: ConstTexts.startTestButtonText, // "Ön Değerlendirme"
                  onTap: () {
                    // FIX: Navigate directly to the working questionnaire
                    Get.to(() => const QuestionnaireView());
                  },
                  backgroundColor: AppColors.secondary,
                  textColor: AppColors.white,
                ),
                SizedBox(height: SizeConfig.responsiveHeight(16)),
                Button(
                  text: ConstTexts.registeredPatientLoginButtonText,
                  onTap: () {
                    Get.to(() => PatientLoginView());
                  },
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                ),
                SizedBox(height: SizeConfig.responsiveHeight(16)),
                Button(
                  text: ConstTexts.doctorLoginButtonText,
                  onTap: () {
                    Get.to(() => const DoctorLoginView());
                  },
                  isOutline: true,
                  textColor: AppColors.dark,
                  backgroundColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}