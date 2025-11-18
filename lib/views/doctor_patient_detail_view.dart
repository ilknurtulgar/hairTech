import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/model/user_model.dart';

class DoctorPatientDetailView extends StatefulWidget {
  final UserModel patient;

  const DoctorPatientDetailView({super.key, required this.patient});

  @override
  State<DoctorPatientDetailView> createState() => _DoctorPatientDetailViewState();
}

class _DoctorPatientDetailViewState extends State<DoctorPatientDetailView> {
  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${patient.name} ${patient.surname}',
            style: TextUtility.getStyle(
              color: AppColors.darker,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: ResponsePadding.page(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ad: ${patient.name}', style: TextUtility.getStyle(fontSize: 18)),
                Text('Soyad: ${patient.surname}', style: TextUtility.getStyle(fontSize: 18)),
                Text('Email: ${patient.email}', style: TextUtility.getStyle(fontSize: 16)),
                // Buraya istersen hasta detaylarını ekleyebilirsin
              ],
            ),
          ),
        ),
      ),
    );
  }
}
