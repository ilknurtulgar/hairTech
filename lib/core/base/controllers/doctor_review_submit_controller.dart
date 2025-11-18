// File: lib/core/base/controllers/doctor_review_submit_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../model/review_submission_data.dart'; 
import '../service/database_service.dart'; 

class DoctorReviewSubmitController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>(); 

  final ReviewSubmissionData initialData;

  // ⭐️ FIX: Initialize editable scores to 1.0 (the minimum allowed value) ⭐️
  var growthRating = 1.0.obs;
  var densityRating = 1.0.obs;
  var naturalnessRating = 1.0.obs;
  var healthRating = 1.0.obs;
  var doctorFeedback = ''.obs;

  late final RxDouble patientGrowthRating;
  late final RxDouble patientDensityRating;

  DoctorReviewSubmitController({required this.initialData}) {
    // Set read-only patient data
    patientGrowthRating = initialData.patientGrowthRating.obs;
    patientDensityRating = initialData.patientDensityRating.obs;
    
    // Set initial editable scores to the patient's score if available, otherwise 1.0
    // This provides a meaningful starting point for the doctor.
    growthRating.value = initialData.patientGrowthRating;
    densityRating.value = initialData.patientDensityRating;
    naturalnessRating.value = initialData.patientDensityRating; // Placeholder based on density
    healthRating.value = initialData.patientDensityRating; // Placeholder based on density
  }

  // --- Rating Updaters ---
  void updateGrowthRating(double value) => growthRating.value = value;
  void updateDensityRating(double value) => densityRating.value = value;
  void updateNaturalnessRating(double value) => naturalnessRating.value = value;
  void updateHealthRating(double value) => healthRating.value = value;
  
  void onFeedbackChanged(String value) => doctorFeedback.value = value;

  // --- Submission Logic ---
  Future<void> submitReview() async {
    final overall = (growthRating.value + densityRating.value + naturalnessRating.value + healthRating.value) / 4.0;

    if (doctorFeedback.value.isEmpty) {
       Get.snackbar('Uyarı', 'Lütfen bir geribildirim açıklaması girin.', snackPosition: SnackPosition.BOTTOM);
       return;
    }

    try {
      await _databaseService.submitDoctorReview(
        updateId: initialData.patientId,
        doctorNote: doctorFeedback.value,
        growthRating: growthRating.value,
        densityRating: densityRating.value,
        naturalnessRating: naturalnessRating.value,
        healthRating: healthRating.value,
        overallRating: overall,
      );
      
      Get.snackbar(
        'Başarılı',
        'Geribildirim başarıyla gönderildi!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
      Get.back();
      
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gönderilemedi: Veritabanı hatası.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }
}