import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart'; // <-- Import DatabaseService

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService(); // <-- Init DatabaseService

  // Sign in with Email & Password
  // ... (existing signInWithEmailPassword code)
  Future<dynamic> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // Success! Return the user
    } on FirebaseAuthException catch (e) {
      // Return a user-friendly error message
      print("Firebase Auth Error: ${e.message}");
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return "Email veya şifre hatalı. Lütfen kontrol edin.";
      } else if (e.code == 'invalid-email') {
        return "Geçersiz email formatı.";
      }
      return "Bir hata oluştu. Lütfen tekrar deneyin.";
    } catch (e) {
      print("General Error: $e");
      return "Bir hata oluştu.";
    }
  }

  /// Sign UP with Email, Password, Name, and Role
  Future<dynamic> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String surname, // <-- Added
    required int age, // <-- Added
    required bool isDoctor, // <-- Changed
  }) async {
    try {
      // 1. Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user == null) {
        return "Kullanıcı oluşturulamadı.";
      }

      // 2. Create user document in Firestore
      await _db.createUserData(
        uid: user.uid,
        name: name,
        surname: surname, // <-- Added
        email: email,
        age: age, // <-- Added
        isDoctor: isDoctor, // <-- Changed
      );

      return user; // Success!
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      if (e.code == 'weak-password') {
        return "Şifre çok zayıf.";
      } else if (e.code == 'email-already-in-use') {
        return "Bu email adresi zaten kayıtlı.";
      }
      return "Bir hata oluştu. Lütfen tekrar deneyin.";
    } catch (e) {
      print("General Error: $e");
      return "Bir hata oluştu.";
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}