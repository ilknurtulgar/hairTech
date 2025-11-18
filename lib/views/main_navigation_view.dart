import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/custom_bottomtabbar.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/views/doctor_appointments_view.dart' show DoctorAppointmentsView;
import 'package:hairtech/views/doctor_home_view.dart' show DoctorHomeView;
import 'package:hairtech/views/doctor_patients_view.dart';
import 'patient_home_view.dart';
import 'patient_upload_view.dart';
import 'patient_process_view.dart';
import '../core/base/util/size_config.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0; // Page listesinin index'ini tutar (Hasta için 0 veya 1; Doktor için 0, 1, 2)

  // Controller'lar initState'te bulunacağı için late final yapıldı.
  late final UserController _userController;
  late final PatientHomeController _homeController;
  late final bool _isDoctor;
  
  // Sayfa Listeleri:
  // Hasta için: Home (0), Process (1) -> Not: 1. index bar'da 2. index'e denk gelir.
  final List<Widget> _patientPages = const <Widget>[
    PatientHomeView(),    // 0
    PatientProcessView(), // 1
  ];

  // Doktor için: Home (0), Appointments (1), Patients (2)
  final List<Widget> _doctorPages = const <Widget>[
    DoctorHomeView(),         // 0
    DoctorAppointmentsView(), // 1
    DoctorPatientsView(),     // 2
  ];

  @override
  void initState() {
    super.initState();
    // Controller'ları ve kullanıcı tipini initialize et
    _userController = Get.find<UserController>();
    _homeController = Get.find<PatientHomeController>();
    _isDoctor = _userController.user?.isDoctor ?? false;

    // Stream'leri başlat (daha önceki sorunun çözümü)
    if (_userController.user != null && !_isDoctor) {
      _homeController.initStreams(_userController.user!.uid);
    }
    // NOT: Doktorun da stream'leri varsa burada başlatılmalı.
  }

  void _onItemTapped(int barIndex) {
    if (!_isDoctor && barIndex == 1) {
      // 📸 HASTA İÇİN: Index 1 (Kamera) tıklandığında
      Get.to(() => const PatientUploadView());
      return; // Sayfa index'i değişmez
    }
    
    // 🏠 VE 📈 DİĞER SEKMELER İÇİN (Hem Doktor hem Hasta)
    setState(() {
      if (_isDoctor) {
        // Doktor için: Bar index'leri (0, 1, 2) sayfa index'lerine (0, 1, 2) direkt eşittir.
        _selectedIndex = barIndex;
      } else {
        // Hasta için: Bar index'leri (0, 2) sayfa index'lerine (0, 1) çevrilir.
        // barIndex 0 -> pageIndex 0
        // barIndex 2 -> pageIndex 1
        _selectedIndex = (barIndex == 0) ? 0 : 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final List<Widget> currentPageList = _isDoctor ? _doctorPages : _patientPages;

    // BottomTabBar'daki seçili ikonu doğru göstermek için index çevrimi:
    final int barSelectedIndex = _isDoctor 
        ? _selectedIndex // Doktor için 0, 1, 2
        : (_selectedIndex == 0 ? 0 : 2); // Hasta için 0 ise 0, 1 ise 2'yi göster

    return Scaffold(
      backgroundColor: AppColors.background,
      body: currentPageList[_selectedIndex], // Seçili sayfayı gösterir
      bottomNavigationBar: CustomBottomTabBar(
        selectedIndex: barSelectedIndex,
        onTap: _onItemTapped,
        type: _isDoctor ? BottomTabBarType.doctor : BottomTabBarType.patient,
      ),
    );
  }
}