import 'package:get/get.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/model/appointment_model.dart';
import 'package:hairtech/model/patient_update_model.dart';
import 'package:hairtech/views/doctor_review_submit_view.dart';
import 'doctor_review_submit_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Fixes Undefined class 'Timestamp'
import 'package:hairtech/model/user_model.dart'; // ✅ Fixes Undefined class 'UserModel'
import '../../../model/review_submission_data.dart'; // ✅ Fixes The method 'ReviewSubmissionData' isn't defined
import '../controllers/user_controller.dart';

class DoctorHomeController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  
  // Observable list of appointments
  final RxList<AppointmentModel> appointments = <AppointmentModel>[].obs;
  final RxList<PatientUpdateModel> pendingUpdates = <PatientUpdateModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingUpdates = true.obs;
  //doctor
  /// Initialize streams for doctor's assigned appointments and pending updates home
  void initStreams(String doctorUid) {
    print("🏥 [DoctorHomeController] Initializing streams for doctor: $doctorUid");
    
    // Get doctor's appointments streams
    _dbService.getDoctorAppointments(doctorUid).listen((appointmentList) {
      print("girdim");
      appointments.value = appointmentList;
      isLoading.value = false;
      print("📋 [DoctorHomeController] Loaded ${appointmentList.length} appointments");
    }, onError: (error) {
      print("burada");
      print("❌ [DoctorHomeController] Error loading appointments: $error");
      isLoading.value = false;
    });
      print("çıktım");
    // Get pending patient updates stream
    _dbService.getPendingPatientUpdates(doctorUid).listen((updatesList) {
      pendingUpdates.value = updatesList;
      isLoadingUpdates.value = false;
      print("📸 [DoctorHomeController] Loaded ${updatesList.length} pending updates");
    }, onError: (error) {
     // print("❌ [DoctorHomeController] Error loading pending updates: $error");
      isLoadingUpdates.value = false;
    });
  }

  Future<void> navigateToReviewSubmit(PatientUpdateModel updateModel) async {
    // 1. Check if the update is still pending review 
    if (updateModel.doctorNote != 'Doktorunuzdan geri dönüş bekleniyor.') {
        Get.snackbar('Bilgi', 'Bu paylaşım zaten değerlendirilmiştir.', snackPosition: SnackPosition.BOTTOM);
        return;
    }

    // 2. Fetch Patient's UserModel (Name, Age, Register Date)
    final DatabaseService dbService = Get.find<DatabaseService>();
    final UserModel? patient = await dbService.getUserData(updateModel.patientUid);

    if (patient == null) {
      Get.snackbar('Hata', 'Hasta bilgisi çekilemedi.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 3. Calculate Age Info (e.g., "24 yaş (3. Ay)")
    final Timestamp registerTimestamp = patient.registerDate; 
    final DateTime updateDate = updateModel.date.toDate();
    
    String ageInfo = '';
    
    // Safety check for registerDate, though assumed non-null in UserModel
    final DateTime registerDate = registerTimestamp.toDate();
    final int daysSinceRegistration = updateDate.difference(registerDate).inDays;
    // Calculate months, round down for 'X. Ay' format
    final int monthsSinceRegistration = (daysSinceRegistration / 30).floor(); 
    ageInfo = "${patient.age.toString()} yaş (${monthsSinceRegistration}. Ay)";
    
    // 4. Map data to ReviewSubmissionData
    // We assume updateModel.scores[0] is Growth and scores[1] is Density (Patient Self-Rating)
    final reviewData = ReviewSubmissionData(
      // 🎯 CORRECTED MAPPINGS BELOW:
      patientId: updateModel.uid, // Uses the document ID (updateModel.uid)
      name: patient.name,          // Uses the patient's name
      ageInfo: ageInfo,            // Uses the calculated age string
      // -----------------------------------------------------
      imageUrls: updateModel.imageURLs.cast<String?>(), // Casting List<String> to List<String?>
      patientNote: updateModel.patientNote,
      patientGrowthRating: updateModel.scores.length > 0 ? updateModel.scores[0].toDouble() : 1.0, 
      patientDensityRating: updateModel.scores.length > 1 ? updateModel.scores[1].toDouble() : 1.0,
    );

    // 5. Navigate and bind the controller
    final String uniqueTag = updateModel.uid; 

    Get.to(
      () => DoctorReviewSubmitView(initialData: reviewData),
      binding: BindingsBuilder(
        () => Get.put(DoctorReviewSubmitController(initialData: reviewData), tag: uniqueTag),
      ),
    )?.then((_) {
        // Cleanup the controller instance after closing the screen
        Get.delete<DoctorReviewSubmitController>(tag: uniqueTag);
    });
  }

  /// Clear all data (called on logout)
  void clearData() {
    appointments.clear();
    pendingUpdates.clear();
    isLoading.value = true;
    isLoadingUpdates.value = true;
  }
}
