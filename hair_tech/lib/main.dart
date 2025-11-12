import 'package:flutter/material.dart';
// Updated paths to look inside the 'views' folder
import 'package:hair_tech/views/welcome_screen.dart';
import 'package:hair_tech/views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter', // Using a clean, modern font
      ),
      // We set the initial route to WelcomeScreen
      initialRoute: WelcomeScreen.routeName,
      // We define the available routes in the app
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
      },
    );
  }
}