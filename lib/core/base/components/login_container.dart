import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/const_texts.dart';
import '../util/text_utility.dart';
import 'button.dart';
import 'input_box.dart';

class LoginContainer extends StatelessWidget {
  final String headerText;
  final VoidCallback onLoginTap;
  // You would also pass controllers for email/password here
  // final TextEditingController emailController;
  // final TextEditingController passwordController;

  const LoginContainer({
    super.key,
    required this.headerText,
    required this.onLoginTap,
    // required this.emailController,
    // required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          headerText,
          style: TextUtility.headerStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // E-mail Field
        InputBox(
          // controller: emailController,
          placeholderText: ConstTexts.emailHint,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        // Password Field
        InputBox(
          // controller: passwordController,
          placeholderText: ConstTexts.passwordHint,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        // Login Button
        Button(
          text: ConstTexts.loginButton,
          onTap: onLoginTap,
          backgroundColor: AppColors.green,
          textColor: AppColors.white,
        ),
      ],
    );
  }
}