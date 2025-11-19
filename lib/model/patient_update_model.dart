import 'package:cloud_firestore/cloud_firestore.dart';

class PatientUpdateModel {
  final String uid;
  final String patientUid; // ⭐️ NEW: Required to fetch patient's name/age ⭐️
  final Timestamp date;
  final String patientNote;
  final String doctorNote;
  final List<String> imageURLs;
  final List<int> scores;

  PatientUpdateModel({
    required this.uid,
    required this.patientUid, // ⭐️ ADDED ⭐️
    required this.date,
    required this.patientNote,
    required this.doctorNote,
    required this.imageURLs,
    required this.scores,
  });

  factory PatientUpdateModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    final List<int> safeScores = (data['scores'] as List<dynamic>?)
        ?.map((score) => (score as num).round()) // Casts to num first, then rounds to an int.
        .toList() ?? [0, 0, 0, 0, 0]; // Default value if list is missing.
    // ----------------------------------------
    return PatientUpdateModel(
      uid: doc.id,
      patientUid: data['patientUid'] ?? '', // ⭐️ MAPPED FROM FIRESTORE ⭐️
      date: data['date'] ?? Timestamp.now(),
      patientNote: data['patientNote'] ?? '',
      doctorNote: data['doctorNote'] ?? 'Doktorunuzdan geri dönüş bekleniyor.',
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
      scores: safeScores,
    );
  }
}