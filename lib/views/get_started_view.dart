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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                ImageUtility.logo,
                height: 80,
              ),
              const SizedBox(height: 48),
              Text(
                ConstTexts.getStartedHeader,
                style: TextUtility.headerStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Button(
                text: ConstTexts.startTestButtonText, // "Ön Değerlendirme"
                onTap: () {
                  // FIX: Navigate directly to the working questionnaire
                  Get.to(() => const QuestionnaireView());
                },
                backgroundColor: AppColors.secondary,
                textColor: AppColors.white,
              ),
              const SizedBox(height: 16),
              Button(
                text: ConstTexts.registeredPatientLoginButtonText,
                onTap: () {
                  Get.to(() => const PatientLoginView());
                },
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
              ),
              const SizedBox(height: 16),
              Button(
                text: ConstTexts.doctorLoginButtonText,
                onTap: () {
                  Get.to(() => const DoctorLoginView());
                },
                isOutline: true,
                textColor: AppColors.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}