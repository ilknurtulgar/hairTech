import 'package:flutter/material.dart';
import '../core/base/components/login_container.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/size_config.dart';
import '../core/base/util/padding_util.dart';

class PatientLoginView extends StatelessWidget {
  const PatientLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    // You would initialize controllers here
    // final _emailController = TextEditingController();
    // final _passwordController = TextEditingController();

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
          padding: ResponsePadding.page(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageUtility.logoDark,
                height: SizeConfig.responsiveHeight(150),
              ),
              const SizedBox(height: 48),
              LoginContainer(
                headerText: ConstTexts.patientLoginHeader,
                onLoginTap: () {
                  // print("Patient Login Tapped");
                  // print(_emailController.text);
                  // print(_passwordController.text);
                },
                // emailController: _emailController,
                // passwordController: _passwordController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}