import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/const_texts.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';
import 'button.dart';
import 'image_container.dart';

class NewScheduledAppointments extends StatelessWidget {
  final String date;
  final String day;
  final String time;
  final List<String?> patientImageUrls;
  final String patientName;
  final String patientSurname;
  final String patientAge;
  final VoidCallback onReviewAnswers;

  const NewScheduledAppointments({
    Key? key,
    required this.date,
    required this.day,
    required this.time,
    required this.patientImageUrls,
    required this.patientName,
    required this.patientSurname,
    required this.patientAge,
    required this.onReviewAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(203),
      decoration: BoxDecoration(
        color: AppColors.lightgray,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: ResponsePadding.generalContainer(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$date, $day - $time',
            style: TextUtility.getStyle(
              fontSize: SizeConfig.responsiveWidth(18),
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.darker,
            ),
          ),
          SizedBox(
            height: SizeConfig.responsiveWidth(60),
            child: Row(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index < 4
                        ? SizeConfig.responsiveWidth(2)
                        : 0,
                  ),
                  child: ImageContainer(
                    imageUrl: patientImageUrls[index],
                    size: ImageContainerSize.small,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              '$patientName $patientSurname, $patientAge',
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(16),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: AppColors.darker,
              ),
            ),
          ),
          Button(
            text: ConstTexts.reviewAnswersButtonText,
            onTap: onReviewAnswers,
            buttonWidth: SizeConfig.responsiveWidth(308),
            buttonHeight: SizeConfig.responsiveHeight(40),
            backgroundColor: AppColors.lightBlue,
            textColor: AppColors.darker,
          ),
        ],
      ),
    );
  }
}
