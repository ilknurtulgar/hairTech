import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/base/components/login_container.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/service/auth_service.dart';
import '../core/base/service/database_service.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/size_config.dart';

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

      // Check user type BEFORE login
      final dbService = DatabaseService();
      final userData = await dbService.getUserByEmail(email);
      
      if (userData != null && !userData.isDoctor) {
        // This is a patient account, cannot login as doctor
        print("⚠️ is_doctor: false - Bu hasta hesabı");
        isLoading.value = false;
        
        // Show alert dialog
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Hatalı Giriş'),
                content: const Text(
                  'Bu hesap hasta hesabıdır. Lütfen "Kayıtlı Hasta Girişi" butonunu kullanarak giriş yapın.'
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Close alert
                      Navigator.of(context).pop(); // Go back to previous page
                    },
                    child: const Text('Tamam'),
                  ),
                ],
              );
            },
          );
        }
        return;
      }

      // User type is correct, proceed with login
      final result = await authService.signInWithEmailPassword(email, password);

      if (result is User) {
        print("Doctor Login Success! User ID: ${result.uid}");
        // AuthController will handle the redirect and check user type
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                // Ana sayfaya yönlendir (ör: WelcomeView veya AuthWrapper)
                Get.offAllNamed('/');
              }
            },
          ),
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
              children: [
                Image.asset(
                  ImageUtility.logo,
                  height: SizeConfig.responsiveHeight(80),
                ),
                SizedBox(height: SizeConfig.responsiveHeight(32)),
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
      ),
    );
  }
}