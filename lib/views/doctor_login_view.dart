import 'package:flutter/material.dart';
import '../core/base/components/login_container.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';

class DoctorLoginView extends StatelessWidget {
  const DoctorLoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageUtility.logoDark,
                height: 150,
              ),
              const SizedBox(height: 48),
              LoginContainer(
                headerText: ConstTexts.doctorLoginHeader,
                onLoginTap: () {
                  // print("Doctor Login Tapped");
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