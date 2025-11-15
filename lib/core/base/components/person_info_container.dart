import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

class PersonInfoContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  const PersonInfoContainer({
    Key? key,
    required this.title,
    required this.subtitle,
    this.showArrow = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: SizeConfig.responsiveWidth(348),
      height: SizeConfig.responsiveHeight(100),
      decoration: BoxDecoration(
        color: AppColors.lightgray,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: ResponsePadding.generalContainer(),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
                Icons.account_circle_sharp,
                size: SizeConfig.responsiveWidth(35),
                color: AppColors.darker
              ),
          ),  
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(18),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darker,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: SizeConfig.responsiveHeight(2)),
              Text(
                subtitle,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.darker,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          
          
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios,
              size: SizeConfig.responsiveWidth(10),
              color: AppColors.secondary,
            ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: container,
      );
    }

    return container;
  }
}
