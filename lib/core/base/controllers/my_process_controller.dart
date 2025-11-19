// File: core/base/controllers/my_process_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Added for IconData, though not strictly needed here

// Re-using the structure from the component definition for data modeling
enum ProcessContainerType { patient, doctor }

class ProcessStep {
  final String date;
  final List<String?> imageUrls;
  final String subtitle;
  final String description;
  final ProcessContainerType type;
  final String? doctorFeedbackTitle;
  final String? doctorFeedback;
  final String? growthValue;
  final String? densityValue;
  final String? naturalnessValue;
  final String? healthValue;
  final String? overallValue;

  ProcessStep({
    required this.date,
    required this.imageUrls,
    required this.subtitle,
    required this.description,
    this.type = ProcessContainerType.patient,
    this.doctorFeedbackTitle,
    this.doctorFeedback,
    this.growthValue,
    this.densityValue,
    this.naturalnessValue,
    this.healthValue,
    this.overallValue,
  });
}

class MyProcessController extends GetxController {
  final selectedTab = 2.obs; // The 'Sürecim' (Progress) tab is index 2 in the patient bar
  var processSteps = <ProcessStep>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProcessData();
  }

  void fetchProcessData() {
    // Dummy data matching the design (Turkish labels and two identical containers)
    // Note: I'm setting both to ProcessContainerType.doctor to show the scores
    // as seen in the design, even if the titles are 'Hastanın Notu'.
    processSteps.addAll([
      ProcessStep(
        date: '18/10/2025 - Salı', // Tuesday
        imageUrls: List.generate(5, (index) => 'https://via.placeholder.com/150/808080?Text=Img'),
        subtitle: 'Hastanın Notu',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget tortor tempor, laoreet erat sit amet, semper quam. Phasellus felis massa, aliquet vel eleifend non, commodo nec sem.',
        type: ProcessContainerType.doctor, // Use doctor type to display evaluation scores
        doctorFeedbackTitle: 'Doktorun Geri Bildirimi',
        doctorFeedback: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget tortor tempor, laoreet erat sit amet, semper quam. Phasellus felis massa, aliquet vel eleifend non, commodo nec sem.',
        growthValue: '7/10',
        densityValue: '8/10',
        naturalnessValue: '9/10',
        healthValue: '10/10',
        overallValue: '7.6',
      ),
      ProcessStep(
        date: '18/10/2025 - Salı',
        imageUrls: List.generate(5, (index) => 'https://via.placeholder.com/150/808080?Text=Img'),
        subtitle: 'Hastanın Notu',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget tortor tempor, laoreet erat sit amet, semper quam. Phasellus felis massa, aliquet vel eleifend non, commodo nec sem.',
        type: ProcessContainerType.doctor,
        doctorFeedbackTitle: 'Doktorun Geri Bildirimi',
        doctorFeedback: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget tortor tempor, laoreet erat sit amet, semper quam. Phasellus felis massa, aliquet vel eleifend non, commodo nec sem.',
        growthValue: '7/10',
        densityValue: '8/10',
        naturalnessValue: '9/10',
        healthValue: '10/10',
        overallValue: '7.6',
      ),
    ]);
  }

  void onTabSelected(int index) {
    // You would handle navigation here based on the index
    selectedTab.value = index;
    // Example: if (index == 0) Get.toNamed(Routes.HOME);
    // You might need to update the parent navigation view's index.
    // For this example, we just update the local selected index.
  }

  void onStepTapped(ProcessStep step) {
    // Handle tap action, e.g., view details
    Get.snackbar(
      'Adım Tıklandı',
      'Detaylar için ${step.subtitle}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white70,
    );
  }
}