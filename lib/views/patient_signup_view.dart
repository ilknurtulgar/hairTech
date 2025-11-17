import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/base/components/button.dart';
import '../core/base/components/input_box.dart';
import '../core/base/service/auth_service.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/text_utility.dart';
//import 'package:hairtech/views/main_navigation_view.dart'; // <-- Import this

class PatientSignUpView extends StatefulWidget {
  const PatientSignUpView({super.key});

  @override
  State<PatientSignUpView> createState() => _PatientSignUpViewState();
}

class _PatientSignUpViewState extends State<PatientSignUpView> {
  final AuthService _authService = AuthService();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController(); // <-- Added
  final _ageController = TextEditingController(); // <-- Added
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose(); // <-- Added
    _ageController.dispose(); // <-- Added
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim(); // <-- Added
    final age = int.tryParse(_ageController.text.trim()); // <-- Added
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (name.isEmpty ||
        surname.isEmpty || // <-- Added
        age == null || // <-- Added
        email.isEmpty ||
        password.isEmpty) {
      setState(() {
        _errorMessage = "Tüm alanlar doldurulmalıdır";
        _isLoading = false;
      });
      return;
    }

    final result = await _authService.signUpWithEmailPassword(
      email: email,
      password: password,
      name: name,
      surname: surname, // <-- Added
      age: age, // <-- Added
      isDoctor: false, // <-- Changed
    );

    if (!mounted) return;

    if (result is User) {
      // Success
      // --- UPDATED NAVIGATION ---
      // Pop all screens until we're back at the AuthWrapper
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else if (result is String) {
      // Failure
      setState(() {
        _isLoading = false;
        _errorMessage = result;
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
                ImageUtility.logo,
                height: 80,
              ),
              const SizedBox(height: 32),
              Text(
                ConstTexts.patientSignUpHeader,
                style: TextUtility.headerStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              InputBox(
                controller: _nameController,
                placeholderText: ConstTexts.nameHint, // "İSİM"
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: _surnameController, // <-- Added
                placeholderText: ConstTexts.surnameHint, // "SOYİSİM"
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: _ageController, // <-- Added
                placeholderText: ConstTexts.ageHint, // "YAŞ"
                keyboardType: TextInputType.number, // <-- Set keyboard
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: _emailController,
                placeholderText: ConstTexts.emailHint,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              InputBox(
                controller: _passwordController,
                placeholderText: ConstTexts.passwordHint,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Button(
                text: ConstTexts.signUpButton,
                onTap: _handleSignUp,
                isLoading: _isLoading,
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextUtility.getStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ConstTexts.loginButton,
                    style: TextUtility.getStyle(color: AppColors.dark),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      ConstTexts.loginButton,
                      style: TextUtility.getStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}