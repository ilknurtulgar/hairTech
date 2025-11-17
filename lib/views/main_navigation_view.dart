import 'package:flutter/material.dart';
// Updated import to match your file name
import 'package:hairtech/core/base/components/custom_bottomtabbar.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'patient_home_view.dart';

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
    Scaffold(
        body: Center(
            child: Text(ConstTexts.cameraTabLabel))),
    Scaffold(
        body: Center(
            child: Text(ConstTexts.progressTabLabel))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Index 1 is the camera FAB
      print("Open Camera Modal");
      // You can show a modal or navigate to a camera page here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // The body is the currently selected page
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: CustomBottomTabBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomTabBarType.patient, // <-- Pass the correct type
      ),
    );
  }
}