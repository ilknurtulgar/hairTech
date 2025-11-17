import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/controllers/auth_controller.dart';
//import 'package:hairtech/views/get_started_view.dart';
import '../core/base/components/button.dart';
import '../core/base/util/app_colors.dart';

class DoctorHomeView extends StatelessWidget {
  const DoctorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Hekim Paneli"),
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Button(
            text: "Çıkış Yap",
            onTap: () {
              authController.signOut();
            },
            backgroundColor: AppColors.secondary,
            textColor: AppColors.white,
          ),
        ),
      ),
    );
  }
}