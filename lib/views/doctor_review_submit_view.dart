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

class DoctorReviewSubmitView extends StatelessWidget {
  
  final ReviewSubmissionData initialData;

  const DoctorReviewSubmitView({
    super.key,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final String uniqueTag = initialData.patientId;
   // final controller = Get.find<DoctorReviewSubmitController>(tag: uniqueTag);
     final controller = Get.put(
      DoctorReviewSubmitController(initialData: initialData),
      tag: uniqueTag,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.darker),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Geribildirim Ekle',
          style: TextUtility.getStyle(
            fontSize: SizeConfig.responsiveWidth(20),
            fontWeight: FontWeight.bold,
            color: AppColors.darker,
          ),

        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsePadding.page(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PersonInfoContainer(
                title: controller.initialData.name,
                subtitle: controller.initialData.ageInfo,
              ),
        
              SizedBox(height: SizeConfig.responsiveHeight(20)),
              
             Column(
              children: [
                if (controller.initialData.imageUrls.isNotEmpty)
                  Row(
                    children: controller.initialData.imageUrls
                        .take(3)
                        .map((url) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(SizeConfig.responsiveWidth(2)),
                                child: ImageContainer(
                                  imageUrl: url,
                                  size: ImageContainerSize.big,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                SizedBox(height: SizeConfig.responsiveHeight(5)),
        
                if (controller.initialData.imageUrls.length > 3)
                  Row(
                    children: [
                      ...controller.initialData.imageUrls
                          .skip(3)
                          .take(2)
                          .map((url) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(SizeConfig.responsiveWidth(2)),
                                  child: ImageContainer(
                                    imageUrl: url,
                                    size: ImageContainerSize.big,
                                  ),
                                ),
                              )),
                    
                      if (controller.initialData.imageUrls.length == 5) Expanded(child: SizedBox()),
                      if (controller.initialData.imageUrls.length == 4)
                        Expanded(child: SizedBox()),
                    ],
                  ),
              ],
            ),
              SizedBox(height: SizeConfig.responsiveHeight(15)),
              Text(
                'Hastanın Notu',
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  color: AppColors.darker,
                ),
              ),
              SizedBox(height: SizeConfig.responsiveHeight(10)),
              Text(
                controller.initialData.patientNote,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(16),
                  fontWeight: FontWeight.w400,
                  color: AppColors.darker,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
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
        
              SizedBox(height: SizeConfig.responsiveHeight(15)),
        
              Text(
                'Açıklama',
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  color: AppColors.darker,
                ),
              ),
              SizedBox(height: SizeConfig.responsiveHeight(10)),
              Container(
                height: SizeConfig.responsiveHeight(150),
                decoration: BoxDecoration(
                  color: AppColors.lightgray,
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
              
              SizedBox(height: SizeConfig.responsiveHeight(15)),
        
              Button(
                text: 'Gönder',
                onTap: controller.submitReview,
                backgroundColor: AppColors.secondary,
                textColor: AppColors.white,
                buttonHeight: SizeConfig.responsiveHeight(50),
              ),
              SizedBox(height: SizeConfig.responsiveHeight(15)),
            ],
          ),
        ),
      ),
    );
  }
}