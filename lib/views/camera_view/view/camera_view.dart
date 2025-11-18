import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/views/camera_view/view_model/camera_view_model.dart';

import '../../../core/base/util/size_config.dart';
import '../../../core/base/view/base_view.dart';
import '../../../product/component/camera_viewer.dart';
import '../../../product/component/image_holder.dart';

class CameraView extends StatelessWidget {
  final CameraDescription camera;
  const CameraView({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return BaseView<CameraViewModel>(
      controller: CameraViewModel(),
      onModelReady: (controller) async {
        await controller.initCamera(camera);
        controller.cameraDescription = camera;
        await controller.speechService.initTts();
      },
      buildPage: (context, controller) {
        return Obx(
          () => !controller.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : Scaffold(
                  backgroundColor: const Color(0xFF0B1E33),
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: SizeConfig.responsiveWidth(300), //300,
                          height: SizeConfig.responsiveHeight(400), //400,
                          child: Stack(
                            children: [
                              CustomCameraPreview(
                                cameraController: controller.cameraController,
                              ),
                              images(controller),
                            ],
                          ),
                        ),
                        button(controller),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  InkWell button(CameraViewModel controller) {
    return InkWell(
      onTap: () {
        if (!controller.isStreaming) {
          controller.isStreaming = true;
          controller.startCountdown(); // async olarak başlat
          // kamera stream'i başlat — burada TTS yok
          controller.cameraController.startImageStream((image) async {
            await controller.streamImage(camera, image);
          });
        } else {
          // Fotoğraf çekimini baştan başlatma
          controller.tryAgain();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          height: SizeConfig.responsiveHeight(75), // 75,
          width: SizeConfig.responsiveHeight(75), // 75
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF90A8C3), width: 4),
          ),
          child: const Center(
            child: Icon(
              Icons.photo_camera_outlined,
              color: Color(0xFF90A8C3),
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget images(CameraViewModel controller) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: SizeConfig.responsiveHeight(70), //70,
          width: SizeConfig.responsiveWidth(310), //310,
          decoration: BoxDecoration(
            color: const Color(0xFF90A8C3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Obx(() {
              return Row(
                children: List.generate(controller.imageList.length, (index) {
                  final img = controller.imageList[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ImageHolder(
                      image: img.value,
                      headPose: controller.poses[index],
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}
