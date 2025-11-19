// File: views/my_process_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/size_config.dart';
import '../core/base/util/text_utility.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/components/patient_process_container.dart';
import '../core/base/components/custom_bottomtabbar.dart';
import '../core/base/controllers/my_process_controller.dart';

class MyProcessView extends GetView<MyProcessController> {
  const MyProcessView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure SizeConfig is initialized
    SizeConfig.init(context);

    // Initialize controller if not already present (Get.put)
    Get.lazyPut(() => MyProcessController());

    return Scaffold(
      backgroundColor: AppColors.background, // Assuming AppColors.background is the light background color
      
      // --- AppBar Section ---
      appBar: AppBar(
        // The title "Patient Process Page 00" is light gray and centered, which is often 
        // a property of a Navigation View, but we'll include a simple title here.
        automaticallyImplyLeading: false, // Hide back button for a root-level view
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Patient Process Page 00',
          style: TextUtility.getStyle(
            fontSize: SizeConfig.responsiveWidth(18),
            color: AppColors.darkgray,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),

      // --- Body Section ---
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              ConstTexts.patientsTabLabel,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(36),
                fontWeight: FontWeight.w800,
              ),
            ),
          SizedBox(height: SizeConfig.responsiveHeight(15)),
          
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.processSteps.length,
                itemBuilder: (context, index) {
                  final step = controller.processSteps[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.responsiveHeight(25)),
                    child: PatientProcessContainer(
                      date: step.date,
                      imageUrls: step.imageUrls,
                      subtitle: step.subtitle,
                      description: step.description,
                      //type: step.type,
                      onTap: () => controller.onStepTapped(step),
                      doctorFeedbackTitle: step.doctorFeedbackTitle,
                      doctorFeedback: step.doctorFeedback,
                      growthValue: step.growthValue,
                      densityValue: step.densityValue,
                      naturalnessValue: step.naturalnessValue,
                      healthValue: step.healthValue,
                      overallValue: step.overallValue,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Obx(
        () => CustomBottomTabBar(
          selectedIndex: controller.selectedTab.value,
          onTap: controller.onTabSelected,
          type: BottomTabBarType.patient,
        ),
      ),
    );
  }
}