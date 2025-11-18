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
          height: SizeConfig.responsiveHeight(80), // Increased height
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
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.responsiveHeight(8),
                bottom: SizeConfig.responsiveHeight(4),
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

        // --- This is the Floating Icon Only, layered on top ---
        if (type == BottomTabBarType.patient)
          Positioned(
            // Button positioned so 1/3 is inside, 2/3 is outside the bar
            top: -SizeConfig.responsiveWidth(60) * 2 / 3,
            child: _buildFloatingCameraIcon(),
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
          index: 1,
          isSelected: selectedIndex == 1,
        ),
      ),
      Expanded(
        child: _buildTabItem(
          icon: Icons.show_chart,
          label: ConstTexts.patientsTabLabel,
          index: 2,
          isSelected: selectedIndex == 2,
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
      // --- Section 2: Camera Tab (text only, icon floats above) ---
      Expanded(
        child: GestureDetector(
          onTap: () => onTap(1),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to match icon height in other tabs
              SizedBox(height: SizeConfig.responsiveWidth(22)),
              SizedBox(height: SizeConfig.responsiveHeight(4)),
              Text(
                ConstTexts.cameraTabLabel,
                style: TextStyle(
                  color: selectedIndex == 1 ? AppColors.dark : AppColors.darkgray,
                  fontSize: SizeConfig.responsiveWidth(11),
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
            size: SizeConfig.responsiveWidth(22),
          ),
          SizedBox(height: SizeConfig.responsiveHeight(4)),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: SizeConfig.responsiveWidth(11),
              fontWeight: FontWeight.w400,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCameraIcon() {
    // Only the circular icon that floats above
    return GestureDetector(
      onTap: () => onTap(1),
      child: Container(
        width: SizeConfig.responsiveWidth(70),
        height: SizeConfig.responsiveWidth(70),
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
    );
  }
}