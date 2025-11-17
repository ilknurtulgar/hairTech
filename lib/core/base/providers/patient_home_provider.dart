import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/model/appointment_model.dart';
import 'package:hairtech/model/patient_update_model.dart';

class PatientHomeProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  StreamSubscription? _appointmentsSubscription;
  StreamSubscription? _updatesSubscription;

  List<AppointmentModel> _activeAppointments = [];
  List<PatientUpdateModel> _patientUpdates = [];
  bool _isLoading = false;

  List<AppointmentModel> get activeAppointments => _activeAppointments;
  List<PatientUpdateModel> get patientUpdates => _patientUpdates;
  bool get isLoading => _isLoading;

  // Call this when the user logs in
  void initStreams(String patientUid) {
    _isLoading = true;
    notifyListeners();

    // Cancel any old streams
    _appointmentsSubscription?.cancel();
    _updatesSubscription?.cancel();

    // Listen to new appointments
    _appointmentsSubscription =
        _db.getActiveAppointments(patientUid).listen((data) {
      _activeAppointments = data;
      _isLoading = false; // Stop loading on first data batch
      notifyListeners();
    });

    // Listen to new updates
    _updatesSubscription = _db.getPatientUpdates(patientUid).listen((data) {
      _patientUpdates = data;
      _isLoading = false; // Stop loading on first data batch
      notifyListeners();
    });
  }

  // Call this on logout
  void clearData() {
    _appointmentsSubscription?.cancel();
    _updatesSubscription?.cancel();
    _activeAppointments = [];
    _patientUpdates = [];
    notifyListeners();
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }
}