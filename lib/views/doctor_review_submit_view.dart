// File: lib/views/doctor_review_submit_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Imports
import '../core/base/util/size_config.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/text_utility.dart';
import '../core/base/util/padding_util.dart';
import '../core/base/components/person_info_container.dart';
import '../core/base/components/image_container.dart';
import '../core/base/components/button.dart';
import '../core/base/controllers/doctor_review_submit_controller.dart'; 
import '../model/review_submission_data.dart'; 
import '../core/base/components/evaluation_bar.dart'; 

// ⭐️ Static component for displaying read-only scores ⭐️
class _EvaluationDisplay extends StatelessWidget {
  final String label;
  final double value;
  final double max;

  const _EvaluationDisplay({
    required this.label, 
    required this.value, 
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.responsiveHeight(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(18),
                fontWeight: FontWeight.w500,
                color: AppColors.dark,
              ),
            ),
            Text(
              '${value.round()}/${max.round()}',
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(18),
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
        // Use a disabled Slider for visual representation of the patient's score
        SliderTheme(
          data: SliderThemeData(
            trackHeight: SizeConfig.responsiveHeight(4),
            activeTrackColor: AppColors.darkgray, 
            inactiveTrackColor: AppColors.lightgray,
            thumbColor: AppColors.darkgray,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: SizeConfig.responsiveWidth(10),
            ),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
          ),
          child: Slider(
            value: value,
            min: 1.0,
            max: max,
            divisions: max.round() - 1,
            onChanged: null, // Disabled
          ),
        ),
      ],
    );
  }
}

class DoctorReviewSubmitView extends GetView<DoctorReviewSubmitController> {
  
  final ReviewSubmissionData initialData;

  const DoctorReviewSubmitView({
    super.key,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    final String uniqueTag = initialData.patientId; 
    
    if (!Get.isRegistered<DoctorReviewSubmitController>(tag: uniqueTag)) {
      Get.put(DoctorReviewSubmitController(initialData: initialData), tag: uniqueTag);
    }
    
    final controller = Get.find<DoctorReviewSubmitController>(tag: uniqueTag);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.dark),
          onPressed: () {
            Get.delete<DoctorReviewSubmitController>(tag: uniqueTag); 
            Get.back();
          },
        ),
        title: Text(
          'Geribildirim Ekle',
          style: TextUtility.getStyle(
            fontSize: SizeConfig.responsiveWidth(20),
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: ResponsePadding.page(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Patient Info Header ---
            PersonInfoContainer(
              title: controller.initialData.name,
              subtitle: controller.initialData.ageInfo,
              onTap: () {},
            ),

            SizedBox(height: SizeConfig.responsiveHeight(20)),
            
            // --- 2. Image Grid ---
            SizedBox(
              height: SizeConfig.responsiveWidth(180),
              child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.initialData.imageUrls.length > 4 ? 4 : controller.initialData.imageUrls.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: SizeConfig.responsiveWidth(10),
                      mainAxisSpacing: SizeConfig.responsiveHeight(10),
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return ImageContainer(
                        imageUrl: controller.initialData.imageUrls[index],
                        size: ImageContainerSize.big,
                      );
                    },
                  ),
            ),

            SizedBox(height: SizeConfig.responsiveHeight(30)),

            // --- 3. Hastanın Notu (Patient's Note) ---
            Text(
              'Hastanın Notu',
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(20),
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(10)),
            Text(
              controller.initialData.patientNote,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(14),
                fontWeight: FontWeight.w400,
                color: AppColors.dark,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            
            // ⭐️ 4. Patient Self-Evaluation (Read-Only) ⭐️
            Obx(() => _EvaluationDisplay(
                label: 'Uzama',
                value: controller.patientGrowthRating.value,
                max: 5.0,
            )),
            Obx(() => _EvaluationDisplay(
                label: 'Yoğunluk',
                value: controller.patientDensityRating.value,
                max: 5.0,
            )),

            SizedBox(height: SizeConfig.responsiveHeight(20)),
            
            // --- 5. Doctor's Review Sliders (Editable) ---
            Text(
              'Geribildirim Ekle',
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(24),
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
            
            // ⭐️ Editable Sliders using EvaluationBar ⭐️
            Obx(() => EvaluationBar(
              title: 'Uzama',
              initialValue: controller.growthRating.value,
              onValueChanged: controller.updateGrowthRating,
            )),
            Obx(() => EvaluationBar(
              title: 'Yoğunluk',
              initialValue: controller.densityRating.value,
              onValueChanged: controller.updateDensityRating,
            )),
            Obx(() => EvaluationBar(
              title: 'Doğallık',
              initialValue: controller.naturalnessRating.value,
              onValueChanged: controller.updateNaturalnessRating,
            )),
            Obx(() => EvaluationBar(
              title: 'Sağlık',
              initialValue: controller.healthRating.value,
              onValueChanged: controller.updateHealthRating,
            )),

            SizedBox(height: SizeConfig.responsiveHeight(30)),

            // --- 6. Açıklama (Doctor's Description/Feedback) ---
            Text(
              'Açıklama',
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(20),
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(10)),
            Container(
              height: SizeConfig.responsiveHeight(150),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.lightgray, width: 1),
              ),
              child: TextField(
                onChanged: controller.onFeedbackChanged,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: ResponsePadding.page(),
                  hintText: 'Doktorun geribildirimini buraya yazın...',
                  hintStyle: TextUtility.getStyle(
                    fontSize: SizeConfig.responsiveWidth(14),
                    color: AppColors.darkgray,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: SizeConfig.responsiveHeight(30)),

            // --- 7. Gönder (Submit) Button ---
            Button(
              text: 'Gönder',
              onTap: controller.submitReview,
              backgroundColor: AppColors.secondary,
              textColor: AppColors.white,
              buttonHeight: SizeConfig.responsiveHeight(50),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(40)),
          ],
        ),
      ),
    );
  }
}