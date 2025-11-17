import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';
import 'evaluation_item.dart';
import 'image_container.dart';
import '../../../views/fullscreen_image_view.dart';

enum ProcessContainerType { patient, doctor }

class PatientProcessContainer extends StatelessWidget {
  final String date;
  final List<String?> imageUrls;
  final String subtitle;
  final String description;
  final ProcessContainerType type;
  final VoidCallback? onTap;
  final String? doctorFeedbackTitle;
  final String? doctorFeedback;
  final String? growthValue;
  final String? densityValue;
  final String? naturalnessValue;
  final String? healthValue;
  final String? overallValue;

  const PatientProcessContainer({
    Key? key,
    required this.date,
    required this.imageUrls,
    required this.subtitle,
    required this.description,
    this.type = ProcessContainerType.patient,
    this.onTap,
    this.doctorFeedbackTitle,
    this.doctorFeedback,
    this.growthValue,
    this.densityValue,
    this.naturalnessValue,
    this.healthValue,
    this.overallValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerHeight = type == ProcessContainerType.doctor
        ? SizeConfig.responsiveHeight(358)
        : SizeConfig.responsiveHeight(218);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.responsiveWidth(348),
        height: containerHeight,
        decoration: BoxDecoration(
          color: AppColors.lightgray,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: ResponsePadding.generalContainerLarge(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(18),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: AppColors.darker,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(5)),
            SizedBox(
              height: SizeConfig.responsiveWidth(60),
              child: Row(
                children: List.generate(
                  imageUrls.length > 5 ? 5 : imageUrls.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index < 4 && index < imageUrls.length - 1
                          ? SizeConfig.responsiveWidth(2)
                          : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // If the URL is valid, open the full-screen view
                        if (imageUrls[index] != null &&
                            imageUrls[index]!.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageView(
                                imageUrl: imageUrls[index]!,
                              ),
                            ),
                          );
                        }
                      },
                      child: ImageContainer(
                        imageUrl: imageUrls[index],
                        size: ImageContainerSize.small,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(5)),
            Text(
              subtitle,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(16),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: AppColors.darker,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(3)),
            Text(
              description,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(12),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: AppColors.darker,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (type == ProcessContainerType.doctor && doctorFeedbackTitle != null) ...[
              SizedBox(height: SizeConfig.responsiveHeight(10)),
              Text(
                doctorFeedbackTitle!,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(16),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
              ),
              SizedBox(height: SizeConfig.responsiveHeight(3)),
              Text(
                doctorFeedback ?? '',
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(12),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (growthValue != null && densityValue != null && naturalnessValue != null && healthValue != null && overallValue != null) ...[
                SizedBox(height: SizeConfig.responsiveHeight(10)),
                EvaluationItem(
                  growthValue: growthValue!,
                  densityValue: densityValue!,
                  naturalnessValue: naturalnessValue!,
                  healthValue: healthValue!,
                  overallValue: overallValue!,
                  valueColor: AppColors.darker,
                  valueFontSize: SizeConfig.responsiveWidth(14),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
