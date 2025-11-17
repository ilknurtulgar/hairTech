import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/model/appointment_model.dart';
import 'package:hairtech/model/patient_update_model.dart';

class DoctorHomeProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  StreamSubscription? _appointmentsSubscription;
  StreamSubscription? _updatesSubscription;

  List<AppointmentModel> _activeAppointments = [];
  List<PatientUpdateModel> _patientUpdates = [];

  // --- THIS IS THE FIX ---
  // We track loading for each stream separately
  bool _isLoadingAppointments = true;
  bool _isLoadingUpdates = true;

  List<AppointmentModel> get activeAppointments => _activeAppointments;
  List<PatientUpdateModel> get patientUpdates => _patientUpdates;
  
  // Getters for the new loading states
  bool get isLoadingAppointments => _isLoadingAppointments;
  bool get isLoadingUpdates => _isLoadingUpdates;
  
  // The "main" isLoading is true if *either* stream is loading
  bool get isLoading => _isLoadingAppointments || _isLoadingUpdates;

  // Call this when the user logs in
  void initStreams(String patientUid) {
    // Cancel any old streams
    _appointmentsSubscription?.cancel();
    _updatesSubscription?.cancel();

    // Reset loading flags
    _isLoadingAppointments = true;
    _isLoadingUpdates = true;

    // We must notify listeners *after* the build frame
    // to avoid the "setState during build" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    // Listen to new appointments
    _appointmentsSubscription =
        _db.getActiveAppointments(patientUid).listen((data) {
      _activeAppointments = data;
      _isLoadingAppointments = false; // This stream is done
      notifyListeners();
    });

    // Listen to new updates
    _updatesSubscription = _db.getPatientUpdates(patientUid).listen((data) {
      _patientUpdates = data;
      _isLoadingUpdates = false; // This stream is done
      notifyListeners();
    });
  }

  // Call this on logout
  void clearData() {
    _appointmentsSubscription?.cancel();
    _updatesSubscription?.cancel();
    _activeAppointments = [];
    _patientUpdates = [];
    _isLoadingAppointments = true;
    _isLoadingUpdates = true;
    notifyListeners();
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }
}