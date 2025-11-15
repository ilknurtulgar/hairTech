import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/const_texts.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class AppointmentInformantContainer extends StatelessWidget {
  final String date;
  final String day;
  final String time;

  const AppointmentInformantContainer({
    Key? key,
    required this.date,
    required this.day,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(90),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.responsiveWidth(20),
        vertical: SizeConfig.responsiveHeight(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ConstTexts.activeAppointmentLabel,
            style: TextUtility.getStyle(
              fontSize: SizeConfig.responsiveWidth(16),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: SizeConfig.responsiveHeight(5)),
          Text(
            '$date, $day - $time',
            style: TextUtility.getStyle(
              fontSize: SizeConfig.responsiveWidth(16),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
