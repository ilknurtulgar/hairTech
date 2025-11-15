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
    return SizedBox(
      width: SizeConfig.responsiveWidth(402),
      height: SizeConfig.responsiveHeight(68),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: SizeConfig.responsiveWidth(402),
            height: SizeConfig.responsiveHeight(68),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: type == BottomTabBarType.patient
                      ? _buildPatientTabBar()
                      : _buildDoctorTabBar(),
                ),
              ),
            ),
          ),
          if (type == BottomTabBarType.patient)
            Positioned(
              top: SizeConfig.responsiveHeight(-28),
              left: SizeConfig.responsiveWidth(201) - SizeConfig.responsiveWidth(28),
              child: _buildFloatingCameraButton(),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildDoctorTabBar() {
    return [
      _buildTabItem(
        icon: Icons.home,
        label: ConstTexts.homeTabLabel,
        index: 0,
        isSelected: selectedIndex == 0,
      ),
      _buildTabItem(
        icon: Icons.calendar_today,
        label: ConstTexts.appointmentsTabLabel,
        index: 2,
        isSelected: selectedIndex == 2,
      ),
      _buildTabItem(
        icon: Icons.show_chart,
        label: ConstTexts.patientsTabLabel,
        index: 3,
        isSelected: selectedIndex == 3,
      ),
    ];
  }

  List<Widget> _buildPatientTabBar() {
    return [
      _buildTabItem(
        icon: Icons.home,
        label: ConstTexts.homeTabLabel,
        index: 0,
        isSelected: selectedIndex == 0,
      ),
      SizedBox(width: SizeConfig.responsiveWidth(56)),
      _buildTabItem(
        icon: Icons.show_chart,
        label: ConstTexts.progressTabLabel,
        index: 2,
        isSelected: selectedIndex == 2,
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
    
    return GestureDetector(
      onTap: () => onTap(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SizeConfig.responsiveWidth(56),
            height: SizeConfig.responsiveWidth(56),
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
              fontSize: SizeConfig.responsiveWidth(14),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
