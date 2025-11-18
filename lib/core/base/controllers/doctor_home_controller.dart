import 'package:get/get.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/model/appointment_model.dart';
import 'package:hairtech/model/patient_update_model.dart';

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

  /// Clear all data (called on logout)
  void clearData() {
    appointments.clear();
    pendingUpdates.clear();
    isLoading.value = true;
    isLoadingUpdates.value = true;
  }
}
