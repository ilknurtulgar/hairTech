import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/size_config.dart'; // Assuming this path
import 'package:hairtech/core/base/util/padding_util.dart'; // <-- 1. Import ResponsePadding
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
        const InputBox(
          // controller: emailController,
          placeholderText: ConstTexts.emailHint,
          keyboardType: TextInputType.emailAddress,
        ),
        // 3. Use the spacing value
        SizedBox(height: formSpacing),
        // Password Field
        const InputBox(
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
            backgroundColor: AppColors.green, // <-- Fixed to successGreen
            textColor: AppColors.white,
            buttonWidth: SizeConfig.responsiveWidth(180),
            buttonHeight: SizeConfig.responsiveHeight(50),
          ),
        ),
      ],
    );
  }
}