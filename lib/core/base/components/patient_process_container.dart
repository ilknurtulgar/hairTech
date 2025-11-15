import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';
import 'image_container.dart';

class PatientProcessContainer extends StatelessWidget {
  final String date;
  final List<String?> imageUrls;
  final String subtitle;
  final String description;

  const PatientProcessContainer({
    Key? key,
    required this.date,
    required this.imageUrls,
    required this.subtitle,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(218),
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
                  child: ImageContainer(
                    imageUrl: imageUrls[index],
                    size: ImageContainerSize.small,
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
          Expanded(
            child: Text(
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
          ),
        ],
      ),
    );
  }
}
