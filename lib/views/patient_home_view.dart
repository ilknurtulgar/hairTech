import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/graphic_container.dart';
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

  @override
  Widget build(BuildContext context) {
    final PatientHomeController homeController =
        Get.find<PatientHomeController>();
    final AuthController authController = Get.find<AuthController>();

    // Use addPostFrameCallback to safely call initStreams
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.user != null && !homeController.isLoading) {
        homeController.initStreams(controller.user!.uid);
      }
    });*/

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

              final userName = "${controller.user!.name}";
              final graphData =
                  _transformUpdateData(homeController.patientUpdates);

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${ConstTexts.welcomeBack}\n$userName!",
                        style: TextUtility.getStyle(
                          fontSize: SizeConfig.responsiveHeight(36),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(AppIcons.logout,
                            color: AppColors.secondary, size: 30),
                        onPressed: () async {
                          await authController.signOut();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (graphData.isNotEmpty)
                    GraphicContainer(data: graphData)
                  else
                    Container(
                      height: 350,
                      alignment: Alignment.center,
                      child: const Text("Grafik verisi bulunmuyor."),
                    ),
                  const Expanded(child: SizedBox()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}