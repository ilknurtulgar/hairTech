import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/base/components/login_container.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/service/auth_service.dart';
import '../core/base/util/img_utility.dart';
//import '../core/base/util/text_utility.dart';

class DoctorLoginView extends StatelessWidget {
  const DoctorLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isLoading = false.obs;
    final errorMessage = Rx<String?>(null);

    void handleLogin() async {
      FocusScope.of(context).unfocus();
      isLoading.value = true;
      errorMessage.value = null;

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = "Email ve şifre boş olamaz";
        isLoading.value = false;
        return;
      }

      final result = await authService.signInWithEmailPassword(email, password);

      if (result is User) {
        // TODO: Add extra check: is this user a doctor?
        print("Doctor Login Success! User ID: ${result.uid}");
        // AuthController will handle the redirect.
        isLoading.value = false;
      } else if (result is String) {
        errorMessage.value = result;
        isLoading.value = false;
      }
    }

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
            children: [
              Image.asset(
                ImageUtility.logo,
                height: 80,
              ),
              const SizedBox(height: 32),
              Obx(() => LoginContainer(
                    headerText: ConstTexts.doctorLoginHeader,
                    emailController: emailController,
                    passwordController: passwordController,
                    isLoading: isLoading.value,
                    errorMessage: errorMessage.value,
                    onLoginTap: handleLogin,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}