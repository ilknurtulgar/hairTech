import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/text_utility.dart';
import '../core/base/util/size_config.dart';
import '../core/base/components/button.dart';
import '../core/base/components/person_info_container.dart';
import '../core/base/components/appointment_table.dart';
import '../core/base/components/date_tabbar.dart';
import '../core/base/service/database_service.dart';
import '../model/user_model.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentView extends StatefulWidget {
  final VoidCallback? onAppointmentConfirmed;
  const AppointmentView({super.key, this.onAppointmentConfirmed});

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
      void debugPrintAvailableDates(List<DateTime> dates) {
        print('Firestore availableDates:');
        for (final date in dates) {
          print('${getTurkishDayShort(date)}, ${date.day} - $date');
        }
      }
    String getTurkishDayShort(DateTime date) {
      const days = ['Paz', 'Pzt', 'Sl', 'Çrş', 'Prş', 'Cum', 'Cmt'];
      return days[date.weekday % 7];
    }
  int? selectedDateIndex;
  UserModel? selectedDoctor;
  List<UserModel> doctorList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final db = DatabaseService();
    final query = await db.firestore.collection('users').where('is_doctor', isEqualTo: true).get();
    final docs = query.docs;
    for (final doc in docs) {
      print('DEBUG: Doctor doc: ' + doc.data().toString());
      if (doc.data().containsKey('availability')) {
        print('DEBUG: availability type: ' + doc.data()['availability'].runtimeType.toString());
        print('DEBUG: availability value: ' + doc.data()['availability'].toString());
      }
    }
    if (mounted) {
      setState(() {
        doctorList = docs.map((doc) => UserModel.fromFirestore(doc)).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableDates = selectedDoctor?.availability ?? [];
    // Saatleri grupla: Map<String, List<String>> ("2025-11-20" -> ["09:00", "14:00"])
    Map<String, List<String>> dateToTimes = {};
    for (final dt in availableDates) {
      final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      // Her zaman ekle, tekrar eden saatler de dahil
      dateToTimes.putIfAbsent(key, () => []).add(time);
    }
    // Debug: dateToTimes içeriğini yazdır
    print('dateToTimes:');
    dateToTimes.forEach((k, v) => print('$k -> $v'));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.responsiveWidth(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Randevu Planla',
              style: TextUtility.headerStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.responsiveHeight(24)),
            Text(
              'Doktor Seç',
              style: TextUtility.subheaderStyle,
            ),
            SizedBox(height: SizeConfig.responsiveHeight(12)),
            Builder(
              builder: (_) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (doctorList.isEmpty) {
                  return Text('Sistemde doktor bulunamadı.', style: TextUtility.getStyle(color: AppColors.secondary));
                } else {
                  return Column(
                    children: doctorList.map((doctor) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: PersonInfoContainer(
                        title: '${doctor.name} ${doctor.surname}',
                        subtitle: doctor.email,
                        isSelected: selectedDoctor?.uid == doctor.uid,
                        borderColor: selectedDoctor?.uid == doctor.uid ? AppColors.secondary : Colors.transparent,
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              if (selectedDoctor?.uid == doctor.uid) {
                                selectedDoctor = null;
                                selectedDateIndex = null;
                              } else {
                                selectedDoctor = doctor;
                                selectedDateIndex = null;
                              
                              }
                            });
                          }
                        },
                      ),
                    )).toList(),
                  );
                }
              },
            ),
            SizedBox(height: SizeConfig.responsiveHeight(24)),
            Text(
              'Tarih & Saat',
              style: TextUtility.subheaderStyle,
            ),
            if (selectedDoctor != null && availableDates.isNotEmpty)
              Builder(
                builder: (_) {
                  debugPrintAvailableDates(availableDates);
                  // Benzersiz günler için DateItem listesi oluştur
                  final uniqueDates = <String, DateTime>{};
                  for (final dt in availableDates) {
                    final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
                    uniqueDates[key] = dt;
                  }
                  final dateItems = uniqueDates.values.map((date) => DateItem(
                    label: '${getTurkishDayShort(date)}, ${date.day}',
                    date: date,
                  )).toList();
                  // Seçili günün saatlerini bul
                  final selectedIdx = (selectedDateIndex != null && selectedDateIndex! < dateItems.length) ? selectedDateIndex! : 0;
                  final selectedDate = dateItems.isNotEmpty ? dateItems[selectedIdx].date : null;
                  final selectedKey = selectedDate != null ? '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}' : null;
                  final timeSlots = selectedKey != null ? List<String>.from(dateToTimes[selectedKey] ?? []) : <String>[];
                  return AppointmentTable(
                    dates: dateItems,
                    timeSlots: timeSlots,
                    selectedDateIndex: selectedIdx,
                    onDateTabChanged: (index) {
                      if (mounted) {
                        setState(() {
                          selectedDateIndex = index;
                        });
                      }
                    },
                    onAppointmentSelected: (selection) {
                      if (mounted) {
                        setState(() {
                          selectedDateIndex = selection.dateIndex;
                        });
                      }
                      print('Selected: ${selection.date.label} - ${selection.timeSlot}');
                    },
                  );
                },
              ),
            if (selectedDoctor != null && availableDates.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Bu doktorun uygun randevu saati yok.', style: TextUtility.getStyle(color: AppColors.secondary)),
              ),
            SizedBox(height: SizeConfig.responsiveHeight(24)),
            Button(
              text: 'Randevuyu Onayla',
              backgroundColor: AppColors.secondary,
              textColor: AppColors.white,
              onTap: () async {
                if (selectedDoctor == null || selectedDateIndex == null) {
                  Get.snackbar('Hata', 'Lütfen doktor ve tarih seçiniz.');
                  return;
                }
                final userController = Get.find<UserController>();
                final currentUser = userController.user;
                if (currentUser == null) {
                  Get.snackbar('Hata', 'Kullanıcı bulunamadı.');
                  return;
                }
                // Seçili tarih ve saat
                final availableDates = selectedDoctor!.availability;
                final uniqueDates = <String, DateTime>{};
                for (final dt in availableDates) {
                  final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
                  uniqueDates[key] = dt;
                }
                final dateItems = uniqueDates.values.map((date) => DateItem(
                  label: '${getTurkishDayShort(date)}, ${date.day}',
                  date: date,
                )).toList();
                final selectedIdx = (selectedDateIndex != null && selectedDateIndex! < dateItems.length) ? selectedDateIndex! : 0;
                final selectedDate = dateItems.isNotEmpty ? dateItems[selectedIdx].date : null;
                final selectedKey = selectedDate != null ? '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}' : null;
                final dateToTimes = <String, List<String>>{};
                for (final dt in availableDates) {
                  final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
                  final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  dateToTimes.putIfAbsent(key, () => []).add(time);
                }
                final timeSlots = selectedKey != null ? List<String>.from(dateToTimes[selectedKey] ?? []) : <String>[];
                // Seçili saat (ilk saat seçili varsayalım)
                final selectedTime = timeSlots.isNotEmpty ? timeSlots[0] : null;
                if (selectedDate == null || selectedTime == null) {
                  Get.snackbar('Hata', 'Tarih veya saat seçilmedi.');
                  return;
                }
                // Firestore'da 'appointments' koleksiyonu yoksa, ilk belgeyle otomatik olarak oluşturulur.
                // Ekstra bir işlem yapmaya gerek yoktur.
                final db = DatabaseService();
                final appointmentDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  int.parse(selectedTime.split(':')[0]),
                  int.parse(selectedTime.split(':')[1]),
                );
                try {
                  print('Firestore appointment ekleme:');
                  print('patientUid: \'${currentUser.uid}\'');
                  print('doctorUid: \'${selectedDoctor?.uid}\'');
                  print('dateTime: $appointmentDateTime');
                  print('status: active');
                  if (selectedDoctor?.uid == null || selectedDoctor!.uid.isEmpty) {
                    Get.snackbar('Hata', 'Doktor bilgisi eksik veya hatalı. Lütfen tekrar doktor seçin.');
                    print('Firestore appointment ekleme iptal: doctorUid boş veya null');
                    return;
                  }
                  await db.firestore.collection('appointments').add({
                    'patientUid': currentUser.uid,
                    'doctorUid': selectedDoctor!.uid,
                    'dateTime': Timestamp.fromDate(appointmentDateTime),
                    'status': 'active',
                  });
                  // Hasta ana sayfasına yönlendir
                  Get.offAllNamed('/mainNavigation');
                } catch (e, stack) {
                  print('Firestore appointment ekleme hatası: $e');
                  print(stack);
                  Get.snackbar('Hata', 'Randevu kaydedilemedi: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
