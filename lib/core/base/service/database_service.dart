import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hairtech/model/appointment_model.dart'; // <-- Import
import 'package:hairtech/model/patient_update_model.dart'; // <-- Import
import 'package:hairtech/model/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Creates a new user document in the 'users' collection
  /// when a user signs up.
  Future<void> createUserData({
    required String uid,
    required String name,
    required String surname, // <-- Added
    required String email,
    required int age, // <-- Added
    required bool isDoctor, // <-- Changed
  }) async {
    try {
      final now = FieldValue.serverTimestamp();
      // Use .set() to create a document with a specific ID (the uid)
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'surname': surname, // <-- Added
        'email': email,
        'age': age, // <-- Added
        'is_doctor': isDoctor, // <-- Changed (uses underscore for DB field)
        'register-date': now, // <-- Added
        'last-update': now, // <-- Added
      });
    } catch (e) {
      print("Error creating user data: $e");
      // Re-throw the error to be handled by the UI
      throw Exception("Database error");
    }
  }

  /// Fetches a user document from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  // --- NEW METHODS ---

  /// Gets a live stream of the patient's active appointments
  Stream<List<AppointmentModel>> getActiveAppointments(String patientUid) {
    return _db
        .collection('appointments')
        .where('patientUid', isEqualTo: patientUid)
        .where('status', isEqualTo: 'active') // Only get active ones
        .orderBy('dateTime', descending: false) // Get the soonest first
        .snapshots() // This returns a live Stream
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Gets a live stream of the patient's updates (doctor notes)
  Stream<List<PatientUpdateModel>> getPatientUpdates(String patientUid) {
    return _db
        .collection('patient_updates')
        .where('patientUid', isEqualTo: patientUid)
        .orderBy('date', descending: true) // Get the newest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PatientUpdateModel.fromFirestore(doc))
          .toList();
    });
  }

  // TODO:
  // - A service for getting `GraphicContainer` data
  // - A service for getting `nextPhotoUploadDate` from the user doc
}