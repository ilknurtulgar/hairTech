import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/person_info_container.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/model/appointment_model.dart';
import 'package:hairtech/model/user_model.dart';

import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/views/doctor_patient_detail_view.dart';

class DoctorPatientsView extends StatefulWidget {
  const DoctorPatientsView({super.key});

  @override
  State<DoctorPatientsView> createState() => _DoctorPatientsViewState();
}

class _DoctorPatientsViewState extends State<DoctorPatientsView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final userController = Get.find<UserController>();
    final String? doctorUid = userController.user?.uid;
    return SafeArea(
      child: Padding(
        padding: ResponsePadding.page(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ConstTexts.patientsTabLabel,
              style: TextUtility.getStyle(
                fontSize: SizeConfig.responsiveWidth(36),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: SizeConfig.responsiveHeight(16)),
            if (doctorUid != null && doctorUid.isNotEmpty)
              Expanded(
                child: StreamBuilder<List<AppointmentModel>>(
                  stream: DatabaseService().getDoctorAppointments(doctorUid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Benzersiz hasta UID'leri
                    final patientUids = snapshot.data!
                        .map((a) => a.patientUid)
                        .toSet()
                        .toList();
                    if (patientUids.isEmpty) {
                      return const Center(child: Text('Henüz hastanız yok.'));
                    }
                    return ListView.separated(
                      itemCount: patientUids.length,
                      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.responsiveHeight(12)),
                      itemBuilder: (context, index) {
                        final patientUid = patientUids[index];
                        return FutureBuilder<UserModel?>(
                          future: DatabaseService().getUserData(patientUid),
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
                              subtitle: user.email,
                              showArrow: false,
                              onTap: () {
                              //  Get.to(() => DoctorPatientDetailView(patient: user,));
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            if (doctorUid == null || doctorUid.isEmpty)
              const Center(child: Text('Doktor kimliği bulunamadı.')),
          ],
        ),
      ),
    );
  }
}