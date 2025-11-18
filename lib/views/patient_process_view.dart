import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/patient_process_container.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/model/patient_update_model.dart';
import 'package:intl/intl.dart';

class PatientProcessView extends StatelessWidget {
  const PatientProcessView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Get.find<PatientHomeController>();
    final DateFormat formatter = DateFormat('dd/MM/yyyy - EEEE', 'tr_TR');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          ConstTexts.processHeader, // "Sürecim"
          style: TextUtility.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(() => _buildBody(
          context, homeProvider.isLoadingUpdates, homeProvider.patientUpdates, formatter)),
    );
  }

  Widget _buildBody(BuildContext context, bool isLoading,
      List<PatientUpdateModel> updates, DateFormat formatter) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (updates.isEmpty) {
      return const Center(
        child: Text(ConstTexts.noUpdatesYet),
      );
    }

    return ListView.builder(
      padding: ResponsePadding.page(),
      itemCount: updates.length,
      itemBuilder: (context, index) {
        final update = updates[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: PatientProcessContainer(
            date: formatter.format(update.date.toDate()),
            imageUrls: update.imageURLs,
            subtitle: ConstTexts.patientNoteTitle,
            description: update.patientNote,
            type: ProcessContainerType.doctor, // Show all fields

            // Doctor fields
            doctorFeedbackTitle: ConstTexts.doctorNoteTitle,
            doctorFeedback: update.doctorNote,

            // Scores (convert List<int> to String)
            growthValue: update.scores[0].toString(),
            densityValue: update.scores[1].toString(),
            naturalnessValue: update.scores[2].toString(),
            healthValue: update.scores[3].toString(),
            overallValue: update.scores[4].toString(),
          ),
        );
      },
    );
  }
}