import 'package:flutter/material.dart';
import 'package:hairtech/core/base/components/custom_bottomtabbar.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/size_config.dart';
//import 'package:hairtech/core/base/util/const_texts.dart';
import 'patient_upload_view.dart';
import 'patient_home_view.dart';
import 'patient_process_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  // Your new tab bar has 3 indexes: 0 (Home), 1 (Camera), 2 (Progress)
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PatientHomeView(), // Index 0: Ana Sayfa
    PatientProcessView(), // <-- 2. Replace placeholder
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PatientUploadView()),
      );
    }
    setState(() {
      _selectedIndex = (index == 2) ? 1 : 0;
    });
}

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: CustomBottomTabBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomTabBarType.patient, // <-- Pass the correct type
      ),
    );
  }
}