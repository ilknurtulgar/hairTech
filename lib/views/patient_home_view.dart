import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/graphic_container.dart';
import 'package:hairtech/core/base/components/icon_button.dart';
import 'package:hairtech/core/base/components/info_card.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/controllers/auth_controller.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/model/patient_update_model.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:intl/intl.dart';

import '../core/base/components/appointment_informant_container.dart';
import '../core/base/components/patient_process_container.dart' show PatientProcessContainer, ProcessContainerType;
import '../core/base/service/database_service.dart' show DatabaseService;
import '../model/user_model.dart' show UserModel;

class PatientHomeView extends GetView<UserController> {
  const PatientHomeView({super.key});

  Map<String, Map<EvaluationType, double>> _transformUpdateData(
      List<PatientUpdateModel> updates) {
    final Map<String, Map<EvaluationType, double>> transformedData = {};
    final orderedUpdates = updates.reversed.toList();
    for (int i = 0; i < orderedUpdates.length; i++) {
      final update = orderedUpdates[i];
      final weekLabel = "Week ${i + 1}";
      if (update.scores.length == 5) {
        transformedData[weekLabel] = {
          EvaluationType.growth: update.scores[0].toDouble(),
          EvaluationType.density: update.scores[1].toDouble(),
          EvaluationType.naturalness: update.scores[2].toDouble(),
          EvaluationType.health: update.scores[3].toDouble(),
          EvaluationType.overall: update.scores[4].toDouble(),
        };
      }
    }
    return transformedData;
  }

  String? _getNextUploadDate(List<PatientUpdateModel> updates) {
    if (updates.isEmpty) {
      return null;
    }
    
    final lastUpdate = updates.last.date.toDate();
    final nextUploadDate = lastUpdate.add(const Duration(days: 14));
    final formatter = DateFormat('dd MMMM yyyy', 'tr_TR');
    return formatter.format(nextUploadDate);
  }

  @override
  Widget build(BuildContext context) {
    final PatientHomeController homeController = Get.find<PatientHomeController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: ResponsePadding.page(),
          child: Obx(
            () {
              if (controller.isLoading ||
                  homeController.isLoading ||
                  controller.user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final userName =  controller.user!.name;
              final graphData =
                  _transformUpdateData(homeController.patientUpdates);
              final nextUploadDate = _getNextUploadDate(homeController.patientUpdates);
             
              const doctorPhone = "0532 XXX XX XX";

              return SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "${ConstTexts.welcomeBack}\n$userName!",
                              style: TextUtility.getStyle(
                                fontSize: SizeConfig.responsiveHeight(36),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          CustomIconButton(
                            icon: AppIcons.logout,
                            iconColor: AppColors.white,
                            backgroundColor: AppColors.secondary,
                            size: 50,
                            isCircle: true,
                            onTap: () async {
                              await authController.signOut();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.responsiveHeight(24)),
                      GraphicContainer(
                        data: graphData.isNotEmpty
                            ? graphData
                            : {
                                "Week 1": {
                                  EvaluationType.growth: 0.0,
                                  EvaluationType.density: 0.0,
                                  EvaluationType.naturalness: 0.0,
                                  EvaluationType.health: 0.0,
                                  EvaluationType.overall: 0.0,
                                }
                              },
                      ),
                      SizedBox(height: SizeConfig.responsiveHeight(24)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: InfoCard(
                              size: InfoCardSize.big,
                              icon: Icons.calendar_today_rounded,
                              text: ConstTexts.nextPhotoUpload +
                                  (nextUploadDate != null ? '' : ' Henüz başlatılmamış'),
                              date: nextUploadDate,
                              day: '',
                            ),
                          ),
                          SizedBox(width: SizeConfig.responsiveWidth(12)),
                        const Expanded(
                            flex: 1,
                            child: InfoCard(
                              size: InfoCardSize.small,
                              icon: AppIcons.call,
                              text: doctorPhone,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.responsiveHeight(12)),
                      Builder(
                        builder: (_) {
                          final appointments = homeController.activeAppointments;
                          if (appointments.isNotEmpty) {
                            final appt = appointments.first;
                            final apptDate = appt.dateTime.toDate();
                            final dateStr = DateFormat('dd MMMM yyyy', 'tr_TR').format(apptDate);
                            final dayStr = DateFormat('EEEE', 'tr_TR').format(apptDate);
                            final timeStr = DateFormat('HH:mm').format(apptDate);
                            final doctorUid = appt.doctorUid;
                           
                            if (doctorUid.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppointmentInformantContainer(
                                    date: dateStr,
                                    day: dayStr,
                                    time: timeStr,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Doktor bilgisi atanmadı!', style: TextStyle(color: Colors.red)),
                                ],
                              );
                            }
                            return FutureBuilder<UserModel?>(
                              future: DatabaseService().getUserData(doctorUid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppointmentInformantContainer(
                                        date: dateStr,
                                        day: dayStr,
                                        time: timeStr,
                                      ),
                                      const SizedBox(height: 8),
                                      const CircularProgressIndicator(),
                                    ],
                                  );
                                }
                                if (!snapshot.hasData || snapshot.data == null) {
                                 
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppointmentInformantContainer(
                                        date: dateStr,
                                        day: dayStr,
                                        time: timeStr,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('Doktor verisi bulunamadı!', style: TextStyle(color: Colors.red)),
                                    ],
                                  );
                                }
                         
                             
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppointmentInformantContainer(
                                      date: dateStr,
                                      day: dayStr,
                                      time: timeStr,
                                    ),
              
                                  ],
                                );
                              },
                            );
                          } else {
                            return const AppointmentInformantContainer(
                              date: '-',
                              day: '-',
                              time: '-',
                            );
                          }
                        },
                      ),
      
                      SizedBox(height: SizeConfig.responsiveHeight(24)),
                      Text(
                        ConstTexts.lastReviewsFromDoctor,
                        style: TextUtility.getStyle(
                          fontSize: SizeConfig.responsiveWidth(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.darker,
                        ),
                      ),
                      SizedBox(height: SizeConfig.responsiveHeight(12)),
                      Builder(
                        builder: (_) {
                          final updates = homeController.patientUpdates;
                          if (updates.isEmpty) {
                            return const Padding(
                              padding:  EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Henüz yorum yok',
                                style: TextStyle(color: AppColors.darkgray, fontSize: 16),
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: updates.map((update) => PatientProcessContainer(
                              date: DateFormat('dd MMMM yyyy', 'tr_TR').format(update.date.toDate()),
                              imageUrls: update.imageURLs,
                              subtitle: update.patientNote,
                              description: update.doctorNote,
                              type: ProcessContainerType.patient,
                            )).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}