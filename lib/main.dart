import 'package:flutter/material.dart';
import 'views/welcome_view.dart'; // Import the new WelcomeView
import 'core/base/util/size_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      title: 'Hairtech App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: const WelcomeView(), // Set WelcomeView as the starting screen
    );
  }
}