import 'package:flutter/material.dart';
import 'package:hairtech/core/base/components/appointment_informant_container.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/size_config.dart';

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
      debugShowCheckedModeBanner: false,
      home: const AppointmentInformantTestView(),
    );
  }
}

class AppointmentInformantTestView extends StatelessWidget {
  const AppointmentInformantTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Appointment Informant Test'),
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.white,
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              AppointmentInformantContainer(
                date: '15 Kasım 2025',
                day: 'Cuma',
                time: '14:30',
              ),
              SizedBox(height: 20),
              AppointmentInformantContainer(
                date: '20 Aralık 2025',
                day: 'Cumartesi',
                time: '10:00',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

