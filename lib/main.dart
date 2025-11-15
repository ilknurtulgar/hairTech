import 'package:flutter/material.dart';
import 'package:hairtech/core/base/components/new_scheduled_appointments.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/size_config.dart';


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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.background),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const NewScheduledAppointmentsTestView(),
    );
  }
}

class NewScheduledAppointmentsTestView extends StatelessWidget {
  const NewScheduledAppointmentsTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New Scheduled Appointments Test'),
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              NewScheduledAppointments(
                date: '15 Kasım 2025',
                day: 'Cuma',
                time: '14:30',
                patientImageUrls: const [null, null, null, null, null],
                patientName: 'Ahmet',
                patientSurname: 'Yılmaz',
                patientAge: '35',
                onReviewAnswers: () {
                  print('Yanıtları İncele tapped');
                },
              ),
              const SizedBox(height: 20),
              NewScheduledAppointments(
                date: '20 Aralık 2025',
                day: 'Cumartesi',
                time: '10:00',
                patientImageUrls: const [null, null, null, null, null],
                patientName: 'Ayşe',
                patientSurname: 'Demir',
                patientAge: '28',
                onReviewAnswers: () {
                  print('Yanıtları İncele tapped');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

