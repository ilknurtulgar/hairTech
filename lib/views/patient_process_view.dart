import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/patient_process_container.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/model/patient_update_model.dart';
import 'package:intl/intl.dart';

class PatientProcessView extends StatelessWidget {
  const PatientProcessView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); 
    final homeProvider = Get.find<PatientHomeController>();
    final DateFormat formatter = DateFormat('dd/MM/yyyy - EEEE', 'tr_TR');

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea( 
        child: Padding( 
          padding: ResponsePadding.page(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Text(
                ConstTexts.progressTabLabel,
                style: TextUtility.getStyle(
                  fontSize: SizeConfig.responsiveWidth(36),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: SizeConfig.responsiveHeight(16)),

              // 4. Used Expanded to contain the ListView.builder
              Expanded(
                child: Obx(() => _buildContent(
                    context, homeProvider.isLoadingUpdates, homeProvider.patientUpdates, formatter)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading,
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

    // Since Padding is already applied to the Column's body, we remove redundant padding here.
    return ListView.builder(
      // Ensure padding is set to zero as the parent Column already handles it.
      padding: EdgeInsets.zero, 
      itemCount: updates.length,
      itemBuilder: (context, index) {
        final update = updates[index];
        final safeScores = update.scores.length >= 5 ? update.scores : List.filled(5, 0);

        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.responsiveHeight(10)),
          child: PatientProcessContainer(
            date: formatter.format(update.date.toDate()),
            imageUrls: update.imageURLs.cast<String?>(), // Cast to List<String?>
            subtitle: ConstTexts.patientNoteTitle,
            description: update.patientNote,
            type: ProcessContainerType.doctor, 

            doctorFeedbackTitle: ConstTexts.doctorNoteTitle,
            doctorFeedback: update.doctorNote,

            growthValue: safeScores[0].toString(),
            densityValue: safeScores[1].toString(),
            naturalnessValue: safeScores[2].toString(),
            healthValue: safeScores[3].toString(),
            overallValue: safeScores[4].toString(),
          ),
        );
      },
    );
  }
}