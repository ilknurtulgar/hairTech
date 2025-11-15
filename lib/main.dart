import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'core/base/components/question_container.dart';
import 'core/base/components/icon_button.dart';
import 'core/base/util/size_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hairtech App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.background),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: const PersonInfoContainerTestView(), // Test view
    );
  }
}

class PersonInfoContainerTestView extends StatelessWidget {
  const PersonInfoContainerTestView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('PersonInfoContainer Test'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomIconButton(
                    icon: Icons.logout,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout tıklandı!')),
                      );
                    },
                    iconColor: AppColors.white,
                    backgroundColor: AppColors.secondary,
                    size: 56,
                    isCircle: true,
                  ),
                  
  
                  CustomIconButton(
                    icon: Icons.settings,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings tıklandı!')),
                      );
                    },
                    iconColor: AppColors.darker,
                    backgroundColor: Colors.transparent,
                    size: 48,
                    isCircle: false,
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