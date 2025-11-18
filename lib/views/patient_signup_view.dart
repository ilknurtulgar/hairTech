import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/base/components/button.dart';
import '../core/base/components/input_box.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/text_utility.dart';
import '../core/base/service/auth_service.dart';
import 'appointment_view.dart';

class PatientSignUpView extends StatelessWidget {
  const PatientSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final ageController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isLoading = false.obs;
    final errorMessage = Rx<String?>(null);

    void handleSignUp() async {
      FocusScope.of(context).unfocus();
      isLoading.value = true;
      errorMessage.value = null;

      final name = nameController.text.trim();
      final surname = surnameController.text.trim();
      final age = int.tryParse(ageController.text.trim());
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (name.isEmpty ||
          surname.isEmpty ||
          age == null ||
          email.isEmpty ||
          password.isEmpty) {
        errorMessage.value = "Lütfen tüm alanları doldurun.";
        isLoading.value = false;
        return;
      }

      final result = await authService.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
        surname: surname,
        age: age,
        isDoctor: false,
      );

      if (result is User) {
        // Success! AuthController will handle the redirect.
        print("Signup Success! User ID: ${result.uid}");
        isLoading.value = false;
        Get.offAll(() => AppointmentView(
          onAppointmentConfirmed: () {
            Get.offAllNamed('/patientHome');
          },
        ));
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ConstTexts.patientSignUpHeader,
                style: TextUtility.headerStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              InputBox(
                controller: nameController,
                placeholderText: ConstTexts.nameHint,
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: surnameController,
                placeholderText: ConstTexts.surnameHint,
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: ageController,
                placeholderText: ConstTexts.ageHint,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: emailController,
                placeholderText: ConstTexts.emailHint,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: passwordController,
                placeholderText: ConstTexts.passwordHint,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (errorMessage.value != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            errorMessage.value!,
                            style: TextUtility.getStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Button(
                        text: ConstTexts.signUpButton,
                        onTap: handleSignUp,
                        isLoading: isLoading.value,
                        backgroundColor: AppColors.green,
                        textColor: AppColors.white,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}