import 'package:cloud_firestore/cloud_firestore.dart';

class PatientUpdateModel {
  final String uid;
  final Timestamp date;
  final String patientNote;
  final String doctorNote;
  final List<String> imageURLs;
  final List<int> scores;

  PatientUpdateModel({
    required this.uid,
    required this.date,
    required this.patientNote,
    required this.doctorNote,
    required this.imageURLs,
    required this.scores,
  });

  factory PatientUpdateModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return PatientUpdateModel(
      uid: doc.id,
      date: data['date'] ?? Timestamp.now(),
      patientNote: data['patientNote'] ?? '',
      doctorNote: data['doctorNote'] ?? 'Doktorunuzdan geri dönüş bekleniyor.',
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
      scores: List<int>.from(data['scores'] ?? [0, 0, 0, 0, 0]), // Default to 5 scores
    );
  }
}