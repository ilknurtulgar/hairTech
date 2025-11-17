import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/const_texts.dart';
import '../util/size_config.dart';

enum BottomTabBarType { doctor, patient }

class CustomBottomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final BottomTabBarType type;

  const CustomBottomTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Use a Stack to layer the bar and the floating button
    return Stack(
      clipBehavior: Clip.none, // Allow button to "overflow" vertically
      alignment: Alignment.bottomCenter,
      children: [
        // --- This is the bar itself ---
        Container(
          width: double.infinity, // Automatically fill width
          height: SizeConfig.responsiveHeight(60), // Your requested height
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.responsiveHeight(5),
              ),
              child: Row(
                // The Row now contains 3 (or 2) Expanded children
                children: type == BottomTabBarType.patient
                    ? _buildPatientTabBar()
                    : _buildDoctorTabBar(),
              ),
            ),
          ),
        ),

        // --- This is the Floating Button, layered on top ---
        if (type == BottomTabBarType.patient)
          Positioned(
            // 2. Pull the button up so it floats
            top: -SizeConfig.responsiveHeight(28),
            // No 'left' property needed! The Stack's
            // alignment: Alignment.bottomCenter
            // and the Row's 3-part split handle centering.
            child: _buildFloatingCameraButton(),
          ),
      ],
    );
  }

  List<Widget> _buildDoctorTabBar() {
    // 3. Split into 3 equal sections
    return [
      Expanded(
        child: _buildTabItem(
          icon: Icons.home,
          label: ConstTexts.homeTabLabel,
          index: 0,
          isSelected: selectedIndex == 0,
        ),
      ),
      Expanded(
        child: _buildTabItem(
          icon: Icons.calendar_today,
          label: ConstTexts.appointmentsTabLabel,
          index: 2,
          isSelected: selectedIndex == 2,
        ),
      ),
      Expanded(
        child: _buildTabItem(
          icon: Icons.show_chart,
          label: ConstTexts.patientsTabLabel,
          index: 3,
          isSelected: selectedIndex == 3,
        ),
      ),
    ];
  }

  List<Widget> _buildPatientTabBar() {
    // 4. Split into 3 equal sections
    return [
      // --- Section 1: Home ---
      Expanded(
        child: _buildTabItem(
          icon: Icons.home,
          label: ConstTexts.homeTabLabel,
          index: 0,
          isSelected: selectedIndex == 0,
        ),
      ),
      // --- Section 2: Empty Spacer ---
      // This empty box holds the space for the
      // floating button to be centered over.
      Expanded(
        child: Container(),
      ),
      // --- Section 3: Progress ---
      Expanded(
        child: _buildTabItem(
          icon: Icons.show_chart,
          label: ConstTexts.progressTabLabel,
          index: 2,
          isSelected: selectedIndex == 2,
        ),
      ),
    ];
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final color = isSelected ? AppColors.dark : AppColors.darkgray;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        children: [
          Icon(
            icon,
            color: color,
            size: SizeConfig.responsiveWidth(20),
          ),
          SizedBox(height: SizeConfig.responsiveHeight(2)),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: SizeConfig.responsiveWidth(14),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCameraButton() {
    final isSelected = selectedIndex == 1;
    final textColor = isSelected ? AppColors.dark : AppColors.darkgray;

    // 5. REMOVED the Transform.translate.
    // The Positioned widget in build() handles this now.
    return GestureDetector(
      onTap: () => onTap(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SizeConfig.responsiveWidth(60),
            height: SizeConfig.responsiveWidth(60),
            decoration: BoxDecoration(
              color: AppColors.dark,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              color: AppColors.white,
              size: SizeConfig.responsiveWidth(28),
            ),
          ),
          SizedBox(height: SizeConfig.responsiveHeight(4)),
          Text(
            ConstTexts.cameraTabLabel,
            style: TextStyle(
              color: textColor,
              fontSize: SizeConfig.responsiveHeight(12),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}