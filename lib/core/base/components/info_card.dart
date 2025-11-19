import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

enum InfoCardSize { big, small }

class InfoCard extends StatelessWidget {
  final InfoCardSize size;
  final IconData icon;
  final String text;
  final String? date;
  final String? day;

  const InfoCard({
    Key? key,
    required this.size,
    required this.icon,
    required this.text,
    this.date,
    this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = size == InfoCardSize.big
        ? SizeConfig.responsiveWidth(214)
        : SizeConfig.responsiveWidth(129);
    final height = SizeConfig.responsiveHeight(81);

    final content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightgray,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: ResponsePadding.generalContainer(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.darker,
                size: SizeConfig.responsiveWidth(15),
              ),
              SizedBox(width: SizeConfig.responsiveWidth(4)),
              Expanded(
                child: Text(
                  text,
                  style: TextUtility.getStyle(
                    fontSize: SizeConfig.responsiveWidth(12),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: AppColors.darker,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (size == InfoCardSize.big && date != null && day != null) ...[
            SizedBox(height: SizeConfig.responsiveHeight(5)),
            Text(
              '$date, $day',
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(16),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: AppColors.darker,
              ),
            ),
          ],
        ],
      ),
    );

    return content;
  }
}
