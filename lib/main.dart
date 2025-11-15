import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'core/base/components/person_info_container.dart';
import 'core/base/components/result_information_container.dart';
import 'core/base/components/patient_information_container.dart';
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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              
              // PatientInformationContainer
              PatientInformationContainer(
                analysisResult: 'Norwood 4',
                age: '35',
                stage: '6. ay',
              ),
            ],
          ),
        ),
      ),
    );
  }
}