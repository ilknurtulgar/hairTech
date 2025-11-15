import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/size_config.dart';
import '../util/text_utility.dart';
import 'date_tabbar.dart';

class AppointmentTable extends StatefulWidget {
  final List<DateItem> dates;
  final List<String> timeSlots;
  final ValueChanged<AppointmentSelection> onAppointmentSelected;

  const AppointmentTable({
    Key? key,
    required this.dates,
    required this.timeSlots,
    required this.onAppointmentSelected,
  }) : super(key: key);

  @override
  State<AppointmentTable> createState() => _AppointmentTableState();
}

class _AppointmentTableState extends State<AppointmentTable> {
  int? _selectedDateIndex;
  int? _selectedTimeIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateTabBar(
          size: DateTabBarSize.big,
          dates: widget.dates,
          onDateSelected: (index) {
            setState(() {
              _selectedDateIndex = index;
              _selectedTimeIndex = null;
            });
          },
        ),
        SizedBox(height: SizeConfig.responsiveHeight(20)),
        ...List.generate(
          (widget.timeSlots.length / 4).ceil(),
          (rowIndex) {
            final startIndex = rowIndex * 4;
            final endIndex = (startIndex + 4 > widget.timeSlots.length)
                ? widget.timeSlots.length
                : startIndex + 4;
            final rowSlots = widget.timeSlots.sublist(startIndex, endIndex);

            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex < (widget.timeSlots.length / 4).ceil() - 1
                    ? SizeConfig.responsiveHeight(10)
                    : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: rowSlots.asMap().entries.map((entry) {
                  final timeIndex = startIndex + entry.key;
                  final timeSlot = entry.value;
                  final isSelected = _selectedTimeIndex == timeIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimeIndex = timeIndex;
                      });
                      if (_selectedDateIndex != null) {
                        widget.onAppointmentSelected(
                          AppointmentSelection(
                            dateIndex: _selectedDateIndex!,
                            timeIndex: timeIndex,
                            date: widget.dates[_selectedDateIndex!],
                            timeSlot: timeSlot,
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: SizeConfig.responsiveWidth(70),
                      height: SizeConfig.responsiveHeight(40),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary : AppColors.lightgray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.responsiveWidth(8),
                        vertical: SizeConfig.responsiveHeight(5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        timeSlot,
                        style: TextUtility.getStyle(
                          fontSize: SizeConfig.responsiveWidth(14),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: isSelected ? AppColors.white : AppColors.darker,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AppointmentSelection {
  final int dateIndex;
  final int timeIndex;
  final DateItem date;
  final String timeSlot;

  AppointmentSelection({
    required this.dateIndex,
    required this.timeIndex,
    required this.date,
    required this.timeSlot,
  });
}
