import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String uid;
  final Timestamp dateTime;
  final String patientUid;
  final String doctorUid;
  final String status;

  AppointmentModel({
    required this.uid,
    required this.dateTime,
    required this.patientUid,
    required this.doctorUid,
    required this.status,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      uid: doc.id,
      dateTime: data['dateTime'] ?? Timestamp.now(),
      patientUid: data['patientUid'] ?? '',
      doctorUid: data['doctorUid'] ?? '',
      status: data['status'] ?? '',
    );
  }
}