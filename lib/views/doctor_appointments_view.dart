import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/components/date_tabbar.dart';
import 'package:intl/intl.dart';
import 'package:hairtech/core/base/components/person_info_container.dart';
import 'package:hairtech/model/appointment_model.dart';
import 'package:hairtech/model/user_model.dart';
import 'package:hairtech/core/base/service/database_service.dart';

class DoctorAppointmentsView extends StatefulWidget {
  const DoctorAppointmentsView({super.key});

  @override
  State<DoctorAppointmentsView> createState() => _DoctorAppointmentsViewState();
}

class _DoctorAppointmentsViewState extends State<DoctorAppointmentsView> {
  int selectedDateIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final userController = Get.find<UserController>();
    List<DateTime> uniqueSortedDates = [];
    if (userController.user != null && userController.user!.availability.isNotEmpty) {
      final seen = <String, DateTime>{};
      for (final date in userController.user!.availability) {
        final key = "${date.year}-${date.month}-${date.day}";
        if (!seen.containsKey(key)) {
          seen[key] = DateTime(date.year, date.month, date.day);
        }
      }
      uniqueSortedDates = seen.values.toList()
        ..sort((a, b) => a.compareTo(b));
    }
    return SafeArea(
      child: Padding(
        padding: ResponsePadding.page(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ConstTexts.appointmentsTabLabel,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(36),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(16)),
            if (uniqueSortedDates.isNotEmpty)
              DateTabBar(
                size: DateTabBarSize.big,
                dates: uniqueSortedDates.map((date) {
                  final weekday = DateFormat('E', 'tr_TR').format(date);
                  final day = DateFormat('d').format(date);
                  return DateItem(label: "$weekday,$day", date: date);
                }).toList(),
                selectedIndex: selectedDateIndex,
                onDateSelected: (index) {
                  setState(() {
                    selectedDateIndex = index;
                  });
                },
              ),
            SizedBox(height: SizeConfig.responsiveHeight(16)),
            if (uniqueSortedDates.isNotEmpty && userController.user != null && selectedDateIndex < uniqueSortedDates.length)
              Expanded(
                child: _AppointmentsForDate(
                  doctorUid: userController.user!.uid,
                  selectedDate: uniqueSortedDates[selectedDateIndex],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsForDate extends StatelessWidget {
  final String doctorUid;
  final DateTime selectedDate;
  const _AppointmentsForDate({required this.doctorUid, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppointmentModel>>(
      stream: DatabaseService().getDoctorAppointments(doctorUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final appointments = snapshot.data!.where((a) {
          final d = a.dateTime.toDate();
          return d.year == selectedDate.year && d.month == selectedDate.month && d.day == selectedDate.day;
        }).toList();
        if (appointments.isEmpty) {
          return const Center(child: Text('Bu tarihte randevu yok.'));
        }
        return ListView.separated(
          itemCount: appointments.length,
          separatorBuilder: (_, __) => SizedBox(height: SizeConfig.responsiveHeight(12)),
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return FutureBuilder<UserModel?>(
              future: DatabaseService().getUserData(appointment.patientUid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(title: Text('Hasta bilgisi yükleniyor...'));
                }
                if (!userSnapshot.hasData || userSnapshot.data == null) {
                  return const ListTile(title: Text('Hasta bilgisi bulunamadı.'));
                }
                final user = userSnapshot.data!;
                return PersonInfoContainer(
                  title: '${user.name} ${user.surname}',
                  subtitle: DateFormat('HH:mm').format(appointment.dateTime.toDate()),
                  showArrow: false,
                );
              },
            );
          },
        );
      },
    );
  }
}
