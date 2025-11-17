import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String surname; // <-- Added
  final String email;
  final int age; // <-- Added
  final bool isDoctor; // <-- Changed from 'role'
  final Timestamp registerDate; // <-- Added
  final Timestamp lastUpdate; // <-- Added

  UserModel({
    required this.uid,
    required this.name,
    required this.surname, // <-- Added
    required this.email,
    required this.age, // <-- Added
    required this.isDoctor, // <-- Changed
    required this.registerDate, // <-- Added
    required this.lastUpdate, // <-- Added
  });

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      surname: data['surname'] ?? '', // <-- Added
      email: data['email'] ?? '',
      age: data['age'] ?? 0, // <-- Added
      isDoctor: data['is_doctor'] ?? false, // <-- Changed
      registerDate:
          data['register-date'] ?? Timestamp.now(), // <-- Added
      lastUpdate: data['last-update'] ?? Timestamp.now(), // <-- Added
    );
  }
}