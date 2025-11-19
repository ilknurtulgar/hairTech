import 'dart:async';
import 'package:get/get.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/model/appointment_model.dart';
import 'package:hairtech/model/patient_update_model.dart';

class PatientHomeController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();

  final Rx<List<AppointmentModel>> _activeAppointments =
      Rx<List<AppointmentModel>>([]);
  final Rx<List<PatientUpdateModel>> _patientUpdates =
      Rx<List<PatientUpdateModel>>([]);

  final RxBool _isLoadingAppointments = true.obs;
  final RxBool _isLoadingUpdates = true.obs;

  StreamSubscription? _appointmentsSubscription;
  StreamSubscription? _updatesSubscription;

  List<AppointmentModel> get activeAppointments => _activeAppointments.value;
  List<PatientUpdateModel> get patientUpdates => _patientUpdates.value;
  bool get isLoadingAppointments => _isLoadingAppointments.value;
  bool get isLoadingUpdates => _isLoadingUpdates.value;
  bool get isLoading =>
      _isLoadingAppointments.value || _isLoadingUpdates.value;

  void initStreams(String patientUid) {
    _appointmentsSubscription?.cancel();
    _updatesSubscription?.cancel();

    _isLoadingAppointments.value = true;
    _isLoadingUpdates.value = true;

    _appointmentsSubscription =
        _db.getActiveAppointments(patientUid).listen((data) {
      _activeAppointments.value = data;
      _isLoadingAppointments.value = false;
    }, onError: (e) {
      // print("Error in appointments stream: $e");
      _isLoadingAppointments.value = false;
    });

    _updatesSubscription = _db.getPatientUpdates(patientUid).listen((data) {
      _patientUpdates.value = data;
      _isLoadingUpdates.value = false;
  
      print(patientUid);
    

    }, onError: (e) {
      print("Error in updates stream: $e");
      _isLoadingUpdates.value = false;
    });
  }

  void clearData() {
    _appointmentsSubscription?.cancel();
    _updatesSubscription?.cancel();
    _activeAppointments.value = [];
    _patientUpdates.value = [];
    _isLoadingAppointments.value = true;
    _isLoadingUpdates.value = true;
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}