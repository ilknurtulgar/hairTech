import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/service/auth_service.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/views/main_navigation_view.dart';
import 'package:hairtech/views/welcome_view.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<User?> _firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
  StreamSubscription? _authStreamSubscription;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    // Listen to Firebase auth changes
    _authStreamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _firebaseUser.value = user;
      _handleAuthChanged(user);
    });
  }

  /// Handles navigation when auth state changes
  void _handleAuthChanged(User? user) async {
    print("🔄 [AuthController] _handleAuthChanged called");
    print("🔍 User: ${user?.uid}");
    
    if (user == null) {
      print("❌ User is null - going to WelcomeView");
      // User is logged out
      // Clear all user-specific data from other controllers
      Get.find<UserController>().clearUser();
      Get.find<PatientHomeController>().clearData();
      // Go to WelcomeView, remove all other routes
      Get.offAll(() => const WelcomeView());
    } else {
      print("✅ User logged in - checking user type");
      // User is logged in - check if doctor or patient
      try {
        print("📡 Fetching user data from Firestore for UID: ${user.uid}");
        final userData = await DatabaseService().getUserData(user.uid);
        
        print("📋 User data retrieved: Name=${userData?.name}, Email=${userData?.email}");
        print("👨‍⚕️ isDoctor: ${userData?.isDoctor}");
        
        if (userData != null) {
          // Set user data in UserController
          Get.find<UserController>().setUser(userData);
          print("✅ User data set in UserController");
          
            Get.offAll(() => const MainNavigationView());

        } else {
          print("⚠️ User data is null - going to WelcomeView");
          Get.offAll(() => const WelcomeView());
        }
      } catch (e) {
        print("⚠️ Error checking user type: $e");
        // Default to patient view on error
        Get.offAll(() => const MainNavigationView());
      }
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  void onClose() {
    _authStreamSubscription?.cancel();
    super.onClose();
  }
}