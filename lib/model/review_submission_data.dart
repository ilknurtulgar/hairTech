// File: lib/model/review_submission_data.dart

class ReviewSubmissionData {
  final String patientId;
  final String name;
  final String ageInfo; // e.g., "24 yaş (3. Ay)"
  final List<String?> imageUrls;
  final String patientNote;
  final double patientGrowthRating; // 1-5 scale
  final double patientDensityRating; // 1-5 scale

  ReviewSubmissionData({
    required this.patientId,
    required this.name,
    required this.ageInfo,
    required this.imageUrls,
    required this.patientNote,
    required this.patientGrowthRating,
    required this.patientDensityRating,
  });
}