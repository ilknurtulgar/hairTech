import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final int age;
  final bool isDoctor;
  final Timestamp registerDate;
  final Timestamp lastUpdate;
  final List<DateTime> availability;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.age,
    required this.isDoctor,
    required this.registerDate,
    required this.lastUpdate,
    List<DateTime>? availability,
  }) : availability = availability ?? const [];

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    List<DateTime> availability = [];
    if (data['availability'] != null && data['availability'] is List) {
      try {
        availability = (data['availability'] as List)
            .where((item) => item != null && item is Timestamp)
            .map((item) => (item as Timestamp).toDate())
            .toList();
      } catch (e) {
        print('DEBUG: Error parsing availability: $e');
        print('DEBUG: Raw availability value: ' + data['availability'].toString());
      }
    } else {
      print('DEBUG: No availability or not a List for user: ' + (data['name'] ?? '').toString());
    }
    return UserModel(
      uid: data['uid'] != null && (data['uid'] as String).isNotEmpty ? data['uid'] : doc.id,
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
      isDoctor: data['is_doctor'] ?? false,
      registerDate: data['register-date'] ?? Timestamp.now(),
      lastUpdate: data['last-update'] ?? Timestamp.now(),
      availability: availability,
    );
  }
}