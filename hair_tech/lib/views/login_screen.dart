import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false, // No "back" button
      ),
      body: const Center(
        child: Text(
          'Login Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}