import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- 1. Import Get
import '../core/base/components/login_container.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
//import '../core/base/util/text_utility.dart';
//import 'patient_signup_view.dart';
import '../core/base/service/auth_service.dart'; // <-- 2. Import AuthService
import 'package:firebase_auth/firebase_auth.dart'; // <-- 2. Import User

// 3. Change StatefulWidget to StatelessWidget
class PatientLoginView extends StatelessWidget {
  const PatientLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. Create controllers here
    final AuthService authService = Get.find<AuthService>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isLoading = false.obs; // <-- 5. Create observable
    final errorMessage = Rx<String?>(null); // <-- 5. Create observable

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
        // 6. We DON'T pre-fetch data here. The AuthController
        // will see the new user, call Get.offAll(), which will
        // load MainNavigationView, which will load PatientHomeView,
        // which will then load its own data.
        // We also don't navigate. AuthController handles it.
        print("Login Success! User ID: ${result.uid}");
        // We just stop loading. AuthController will handle the redirect.
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
          onPressed: () => Get.back(), // <-- 7. Use Get.back()
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
              // 8. Wrap LoginContainer in Obx
              Obx(() => LoginContainer(
                    headerText: ConstTexts.patientLoginHeader,
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