import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/service/auth_service.dart';
//import 'package:hairtech/views/auth_wrapper.dart';
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
  void _handleAuthChanged(User? user) {
    if (user == null) {
      // User is logged out
      // Clear all user-specific data from other controllers
      Get.find<UserController>().clearUser();
      Get.find<PatientHomeController>().clearData();
      // Go to WelcomeView, remove all other routes
      Get.offAll(() => const WelcomeView());
    } else {
      // User is logged in
      // Go to Main App, remove all other routes
      Get.offAll(() => const MainNavigationView());
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