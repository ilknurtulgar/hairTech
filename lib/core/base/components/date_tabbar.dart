import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/padding_util.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';

enum DateTabBarSize { big, small }

class DateTabBar extends StatefulWidget {
  final DateTabBarSize size;
  final List<DateItem> dates;
  final ValueChanged<int> onDateSelected;
  final int selectedIndex;

  const DateTabBar({
    Key? key,
    required this.size,
    required this.dates,
    required this.onDateSelected,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  State<DateTabBar> createState() => _DateTabBarState();
}

class _DateTabBarState extends State<DateTabBar> {
  int _selectedIndex = 0;
    @override
    void didUpdateWidget(DateTabBar oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (widget.selectedIndex != _selectedIndex) {
        setState(() {
          _selectedIndex = widget.selectedIndex;
        });
      }
    }
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNext() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final itemWidth = widget.size == DateTabBarSize.big
          ? SizeConfig.responsiveWidth(70)
          : SizeConfig.responsiveWidth(58);
      
      if (currentScroll < maxScroll) {
        _scrollController.animateTo(
          currentScroll + itemWidth + SizeConfig.responsiveWidth(10),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth =  SizeConfig.responsiveWidth(75);
      
    final containerHeight = widget.size == DateTabBarSize.big
        ? SizeConfig.responsiveHeight(40)
        : SizeConfig.responsiveHeight(30);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: containerHeight,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.dates.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < widget.dates.length - 1
                        ? ResponsePadding.appointmentScrollSmall()
                        : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      widget.onDateSelected(index);
                    },
                    child: Container(
                      width: containerWidth,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary : AppColors.lightgray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: widget.size == DateTabBarSize.big
                          ? EdgeInsets.symmetric(
                              horizontal: SizeConfig.responsiveWidth(5),
                              vertical: SizeConfig.responsiveHeight(5),
                            )
                          : EdgeInsets.symmetric(
                              horizontal: SizeConfig.responsiveWidth(3),
                              vertical: SizeConfig.responsiveHeight(3),
                            ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.dates[index].label,
                        style: TextUtility.getStyle(
                          fontSize: SizeConfig.responsiveWidth(16),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: isSelected ? AppColors.white : AppColors.darker,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: SizeConfig.responsiveWidth(5)),
        GestureDetector(
          onTap: _scrollToNext,
          child: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.secondary,
            size: SizeConfig.responsiveWidth(20),
          ),
        ),
      ],
    );
  }
}

class DateItem {
  final String label;
  final DateTime date;

  DateItem({
    required this.label,
    required this.date,
  });
}
