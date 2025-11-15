import 'package:flutter/material.dart';
import '../core/base/components/button.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/text_utility.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/size_config.dart';
import 'patient_login_view.dart';
import 'doctor_login_view.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Navigator.of(context).pop(),
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
                ImageUtility.logoDark,
                height: 160,
              ),
              const SizedBox(height: 48),
              Text(
                "Hazırsan\nbaşlayalım!",
                style: TextUtility.headerStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Center (
                child: Button(
                  text: ConstTexts.startTestButtonText,
                  onTap: () {
                    // print("Ön Değerlendirme");
                  },
                  backgroundColor: AppColors.secondary, // Orange
                  textColor: AppColors.white,
                  buttonHeight: SizeConfig.responsiveHeight(80),
                ),
              ),
              const SizedBox(height: 16),
              Center (
                child: Button(
                  text: ConstTexts.registeredPatientLoginButtonText,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PatientLoginView(),
                      ),
                    );
                  },
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  buttonHeight: SizeConfig.responsiveHeight(80),
                ),
              ),
              const SizedBox(height: 16),
              Center (
                child: Button(
                  text: ConstTexts.doctorLoginButtonText,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DoctorLoginView(),
                      ),
                    );
                  },
                  isOutline: true,
                  textColor: AppColors.dark,
                  buttonHeight: SizeConfig.responsiveHeight(80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}