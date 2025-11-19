import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/icon_button.dart';
import 'package:hairtech/core/base/components/patient_process_container.dart';
import 'package:hairtech/core/base/controllers/doctor_home_controller.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/service/auth_service.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/components/new_scheduled_appointments.dart';
import 'package:intl/intl.dart';
import 'package:hairtech/model/user_model.dart';
import 'package:hairtech/core/base/service/database_service.dart';

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({super.key});

  @override
  State<DoctorHomeView> createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {

  @override
  void initState() {
    super.initState();
    // Initialize streams when view is created
    final userController = Get.find<UserController>();
    final doctorHomeController = Get.find<DoctorHomeController>();
    
    if (userController.user != null) {
      doctorHomeController.initStreams(userController.user!.uid);
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    final userController = Get.find<UserController>();
    final doctorHomeController = Get.find<DoctorHomeController>();
    final authService = Get.find<AuthService>();
    
    final userName = userController.user?.name  ?? "yok";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: ResponsePadding.page(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header with logout button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${ConstTexts.welcomeBack}\nDr. $userName!",
                    style: TextUtility.getStyle(
                      fontSize: SizeConfig.responsiveWidth(36),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  CustomIconButton(
                    icon: AppIcons.logout,
                    iconColor: AppColors.white,
                    backgroundColor: AppColors.secondary,
                    size: 50,
                    isCircle: true,
                    onTap: () async {
                      await authService.signOut();
                    },
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.responsiveHeight(24)),
              
              // Section Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConstTexts.newAssignedAppointments,
                  style: TextUtility.getStyle(
                    fontSize: SizeConfig.responsiveWidth(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darker,
                  ),
                ),
              ),
              
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              
              // Appointment Cards List (From Firebase)
              Obx(() {
                if (doctorHomeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (doctorHomeController.appointments.isEmpty) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Henüz randevunuz bulunmamaktadır.",
                      style: TextUtility.getStyle(
                        fontSize: SizeConfig.responsiveWidth(14),
                        color: AppColors.darkgray,
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: doctorHomeController.appointments.map((appointment) {
                    final dateFormat = DateFormat('d MMMM yyyy', 'tr_TR');
                    final dayFormat = DateFormat('EEEE', 'tr_TR');
                    final timeFormat = DateFormat('HH:mm');
                    final dateTime = appointment.dateTime.toDate();
                    return Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.responsiveHeight(12)),
                      child: FutureBuilder<UserModel?>(
                        future: DatabaseService().getUserData(appointment.patientUid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox(
                              height: SizeConfig.responsiveHeight(203),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return NewScheduledAppointments(
                              date: dateFormat.format(dateTime),
                              day: dayFormat.format(dateTime),
                              time: timeFormat.format(dateTime),
                              patientImageUrls: List.filled(5, null),
                              patientName: "-",
                              patientSurname: "-",
                              patientAge: "-",
                              onReviewAnswers: () {
                                print("Review answers for appointment ${appointment.uid}");
                              },
                            );
                          }
                          final patient = snapshot.data!;
                          return NewScheduledAppointments(
                            date: dateFormat.format(dateTime),
                            day: dayFormat.format(dateTime),
                            time: timeFormat.format(dateTime),
                            patientImageUrls: List.filled(5, null), // Hasta foto url'leri eklenebilir
                            patientName: patient.name,
                            patientSurname: patient.surname,
                            patientAge: patient.age.toString(),
                            onReviewAnswers: () {
                              print("Review answers for appointment ${appointment.uid}");
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              }),
              
              SizedBox(height: SizeConfig.responsiveHeight(24)),
              
              // Section Title: Pending Updates
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Geri Bildirim Bekleyen Paylaşımlar",
                  style: TextUtility.getStyle(
                    fontSize: SizeConfig.responsiveWidth(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darker,
                  ),
                ),
              ),
              
              SizedBox(height: SizeConfig.responsiveHeight(16)),
              // Pending Updates List (From Firebase)
              Obx(() {
                if (doctorHomeController.isLoadingUpdates.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (doctorHomeController.pendingUpdates.isEmpty) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Geri bildirim bekleyen paylaşım bulunmamaktadır.",
                      style: TextUtility.getStyle(
                        fontSize: SizeConfig.responsiveWidth(14),
                        color: AppColors.darkgray,
                      ),
                    ),
                  );
                }
                return Column(
                  children: List.generate(
                    doctorHomeController.pendingUpdates.length,
                    (index) {
                      final update = doctorHomeController.pendingUpdates[index];
                      final dateFormat = DateFormat('d MMMM yyyy', 'tr_TR');
                      final date = update.date.toDate();
                      return Padding(
                        padding: EdgeInsets.only(bottom: SizeConfig.responsiveHeight(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PatientProcessContainer(
                              date: dateFormat.format(date),
                              imageUrls: update.imageURLs,
                              subtitle: "Hasta Notu",
                              description: update.patientNote,
                              type: ProcessContainerType.patient,
                              onTap: () {
                                doctorHomeController.navigateToReviewSubmit(update);
                              },
                            ),
                            if (update.doctorNote != "" && update.doctorNote != "Doktorunuzdan geri dönüş bekleniyor.")
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: PatientProcessContainer(
                                  date: dateFormat.format(date),
                                  imageUrls: update.imageURLs,
                                  subtitle: "Doktor Notu",
                                  description: update.doctorNote,
                                  type: ProcessContainerType.doctor,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),)
    );
  }
}