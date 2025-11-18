import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String uid;
  final Timestamp dateTime;
  final String patientUid;
  // You can add doctorUid, status, etc.

  AppointmentModel({
    required this.uid,
    required this.dateTime,
    required this.patientUid,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      uid: doc.id,
      dateTime: data['dateTime'] ?? Timestamp.now(),
      patientUid: data['patientUid'] ?? '',
    );
  }
}