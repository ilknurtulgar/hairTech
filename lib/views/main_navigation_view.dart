import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/custom_bottomtabbar.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart'; // <-- New import
import 'package:hairtech/core/base/util/app_colors.dart';
//import 'package:hairtech/core/base/util/const_texts.dart';
//import 'package:hairtech/core/base/util/icon_utility.dart';
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
  int _selectedIndex = 0;
  
  // 1. Get Controllers
  final UserController _userController = Get.find<UserController>();
  final PatientHomeController _homeController = Get.find<PatientHomeController>();

  @override
  void initState() {
    super.initState();
    // 2. Safely initialize streams ONLY once in initState
    if (_userController.user != null) {
      _homeController.initStreams(_userController.user!.uid);
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    PatientHomeView(), // Index 0: Ana Sayfa
    PatientProcessView(), // Index 2: Sürecim (Mapped to 1)
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      Get.to(() => const PatientUploadView());
    } else {
      setState(() {
        _selectedIndex = (index == 2) ? 1 : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomTabBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomTabBarType.patient,
      ),
    );
  }
}