import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hairtech/model/appointment_model.dart'; // <-- Import
import 'package:hairtech/model/patient_update_model.dart'; // <-- Import
import 'package:hairtech/model/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _db;

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
        if (uid.isEmpty) {
          print("⚠️ [getUserData] UID boş!");
          return null;
        }
    try {
      print("🔍 [getUserData] Fetching document for UID: $uid");
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      print("📄 [getUserData] Document exists: ${doc.exists}");
      
      if (doc.exists) {
        print("✅ [getUserData] Document data: ${doc.data()}");
        return UserModel.fromFirestore(doc);
      } else {
        print("❌ [getUserData] Document does NOT exist for UID: $uid");
        return null;
      }
    } catch (e) {
      print("⚠️ [getUserData] Error getting user data: $e");
      return null;
    }
  }

  /// Fetches a user document from Firestore by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      print("🔍 [getUserByEmail] Fetching document for email: $email");
      QuerySnapshot query = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        print("✅ [getUserByEmail] User found");
        return UserModel.fromFirestore(query.docs.first);
      } else {
        print("❌ [getUserByEmail] No user found with email: $email");
        return null;
      }
    } catch (e) {
      print("⚠️ [getUserByEmail] Error getting user by email: $e");
      return null;
    }
  }

  // --- NEW METHODS ---

  /// Gets a live stream of the patient's active appointments
  Stream<List<AppointmentModel>> getActiveAppointments(String patientUid) {
    return _db
        .collection('appointments')
        .where('patientUid', isEqualTo: patientUid)
        .where('status', isEqualTo: 'active')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
          print('✅ [DB Service] Aktif randevu stream geldi. Toplam belge: ${snapshot.docs.length}');
          for (var doc in snapshot.docs) {
            print('--- Randevu: ${doc.data()}');
          }
          return snapshot.docs
              .map((doc) => AppointmentModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Gets a live stream of the doctor's assigned appointments
  Stream<List<AppointmentModel>> getDoctorAppointments(String doctorUid) {
    return _db
        .collection('appointments')
        .where('doctorUid', isEqualTo: doctorUid)
        .where('status', isEqualTo: 'active') // Only get active ones
        .orderBy('dateTime', descending: false) // Get the soonest first
        .snapshots()
        .map((snapshot) {
          print('✅ [DB Service] Doktorun randevu streami geldi. Toplam belge: ${snapshot.docs.length}');
          for (var doc in snapshot.docs) {
            print('--- Doktor Randevu: ${doc.data()}');
          }
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

  /// Gets a live stream of patient updates waiting for doctor feedback
  Stream<List<PatientUpdateModel>> getPendingPatientUpdates(String doctorUid) {
    return _db
        .collection('patient_updates')
        //.where('doctorUid', isEqualTo: doctorUid)
        //.where('scores', isEqualTo: [0, 0, 0, 0, 0])
        //.where('doctorNote', isEqualTo: 'Doktorunuzdan geri dönüş bekleniyor.')
        .orderBy('date', descending: true) // Get the newest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PatientUpdateModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addPatientUpdate({
    required String patientUid,
    required String patientNote,
    required List<String> imageURLs,
  }) async {
    try {
      await _db.collection('patient_updates').add({
        'patientUid': patientUid,
        'patientNote': patientNote,
        'imageURLs': imageURLs,
        'date': FieldValue.serverTimestamp(),
        'doctorNote': 'Doktorunuzdan geri dönüş bekleniyor.',
        'scores': [0, 0, 0, 0, 0], 
      });
    } catch (e) {
      print("Error adding patient update: $e");
      throw Exception("Update could not be saved.");
    }
  }

  Future<void> submitDoctorReview({
    required String updateId,
    required String doctorNote,
    required double growthRating, // 1-5 scale
    required double densityRating, // 1-5 scale
    required double naturalnessRating, // 1-5 scale
    required double healthRating, // 1-5 scale
    required double overallRating, // 1-5 scale
  }) async {
    try {
      await _db.collection('patient_updates').doc(updateId).update({
        'doctorNote': doctorNote,
        'scores': [
          growthRating.round(),
          densityRating.round(),
          naturalnessRating.round(),
          healthRating.round(),
          overallRating.round(),
        ],
        'last-update': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error submitting doctor review: $e");
      throw Exception("Review could not be saved.");
    }
  }

}