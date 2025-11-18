import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/text_utility.dart';

class InputBox extends StatelessWidget {
  final String placeholderText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const InputBox({
    super.key,
    required this.placeholderText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: _buildInputDecoration(placeholderText),
      textAlign: TextAlign.center,
      style: TextUtility.getStyle(
        color: AppColors.dark,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Helper method to build consistent input decoration
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextUtility.getStyle(
        color: AppColors.darkgray,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      filled: true,
      fillColor: AppColors.lightgray,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}