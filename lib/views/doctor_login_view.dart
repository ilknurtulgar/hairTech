import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- Import User
import '../core/base/components/login_container.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/service/auth_service.dart';
// No SnackBarUtil needed

class DoctorLoginView extends StatefulWidget {
  const DoctorLoginView({super.key});

  @override
  State<DoctorLoginView> createState() => _DoctorLoginViewState();
}

class _DoctorLoginViewState extends State<DoctorLoginView> {
  // 2. CREATE STATE VARIABLES
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage; // <-- Add state for error message

  @override
  void dispose() {
    // 3. Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 4. CREATE LOGIN LOGIC
  void _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear old errors
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final result = await _authService.signInWithEmailPassword(email, password);

    if (result is User) {
      // TODO: Add extra check: is this user a doctor?
      print("Doctor Login Success! User ID: ${result.uid}");
      // Navigate to Doctor Home Page
    } else if (result is String) {
      // Login Failed
      setState(() {
        _errorMessage = result; // <-- Set error message from service
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageUtility.logoDark,
                height: 150,
              ),
              const SizedBox(height: 48),
              LoginContainer(
                headerText: ConstTexts.doctorLoginHeader,
                onLoginTap: _handleLogin,
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                errorMessage: _errorMessage, // <-- Pass the error message
              ),
            ],
          ),
        ),
      ),
    );
  }
}