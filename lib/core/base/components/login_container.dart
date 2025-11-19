import 'package:flutter/material.dart';
import '../util/size_config.dart'; // Assuming this path
import '../util/padding_util.dart'; // <-- 1. Import ResponsePadding
import '../util/app_colors.dart';
import '../util/const_texts.dart';
import '../util/text_utility.dart';
import 'button.dart';
import 'input_box.dart';

class LoginContainer extends StatelessWidget {
  final String headerText;
  final VoidCallback onLoginTap;
  // --- ADDED CONTROLLERS ---
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage; // <-- 1. ADD errorMessage PROPERTY

  const LoginContainer({
    super.key,
    required this.headerText,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTap,
    this.isLoading = false,
    this.errorMessage, // <-- 2. ADD TO CONSTRUCTOR
  });

  @override
  Widget build(BuildContext context) {
    // 2. Get the spacing value from your utility
    final double formSpacing = ResponsePadding.formElements().top; // This is SizeConfig.responsiveHeight(15)

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
          controller: emailController, // <-- Pass controller
          placeholderText: ConstTexts.emailHint,
          keyboardType: TextInputType.emailAddress,
        ),
        // 3. Use the spacing value
        SizedBox(height: formSpacing),
        // Password Field
        InputBox(
          controller: passwordController, // <-- Pass controller
          placeholderText: ConstTexts.passwordHint,
          obscureText: true,
        ),
        // 4. Use the spacing value (or a multiple of it)
        // Original was 24, so maybe 1.5 * spacing, or just use it directly.
        // Let's use it directly for consistency, or you can use `const SizedBox(height: 24)` if that was intentional.
        SizedBox(height: formSpacing),
        // Login Button
        Center(
          child: Button(
            text: ConstTexts.loginButton,
            onTap: onLoginTap,
            isLoading: isLoading, // <-- 3. PASS TO THE BUTTON
            backgroundColor: AppColors.green,
            textColor: AppColors.white,
            buttonWidth: SizeConfig.responsiveWidth(180),
            buttonHeight: SizeConfig.responsiveHeight(50),
          ),
        ),

        // 3. ADD ERROR MESSAGE WIDGET
        SizedBox(height: formSpacing),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: TextUtility.getStyle(
              color: AppColors.secondary, // Your orange error color
              fontSize: SizeConfig.responsiveWidth(14),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}