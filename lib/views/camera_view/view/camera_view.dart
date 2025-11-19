// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/views/camera_view/view_model/camera_view_model.dart';
import 'package:hairtech/views/patient_upload_view.dart';

import '../../../core/base/util/size_config.dart';
import '../../../core/base/view/base_view.dart';
import '../../../product/component/camera_viewer.dart';
import '../../../product/component/image_holder.dart';
import '../../../product/service/camera_service.dart';

class CameraView extends StatelessWidget {
  CameraView({super.key});

  CameraService cameraService = CameraService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cameraService.initCamera(),
      builder: (context, snapshot) {
        /// 1) Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        /// 2) Future error verdiyse
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Camera error: ${snapshot.error}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        /// 3) Data hiç gelmediyse
        if (snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text("Camera initialization returned null")),
          );
        }

        /// 4) Data map ise ama içindeki elemanlar eksikse
        final data = snapshot.data as Map;

        final CameraDescription? camera = data['camera'] as CameraDescription?;

        final CameraController? cameraController =
            data['controller'] as CameraController?;

        /// 5) Kamera bulunamadıysa
        if (camera == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Front camera not available",
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        /// 6) Camera controller oluşmadıysa
        if (cameraController == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Camera controller could not be initialized",
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        /// 7) Her şey yolunda → sayfaya devam et
        return BaseView<CameraViewModel>(
          controller: CameraViewModel(),
          onModelReady: (controller) async {
            controller.cameraController = cameraController;
            await controller.speechService.initTts();
          },
          buildPage: (context, controller) {
            return Scaffold(
              backgroundColor: const Color(0xFF0B1E33),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  backButton(),
                  logoImage(),
                  SizedBox(
                    width: SizeConfig.responsiveWidth(350), //300,
                    height: SizeConfig.responsiveHeight(500), //400,
                    child: Stack(
                      children: [
                        CustomCameraPreview(
                          cameraController: cameraController,
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: images(controller)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        button(controller, camera),
                        const SizedBox(
                          width: 10,
                        ),
                        nextPageButton(controller),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget backButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top:10, left: 15),
        child: InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          )),
      ),
    );
  }

  Padding logoImage() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Image.asset(
          "assets/images/logo.png",
          height: SizeConfig.responsiveHeight(100),
          width: SizeConfig.responsiveHeight(100),
        ));
  }

  InkWell nextPageButton(CameraViewModel controller) {
    return InkWell(
      onTap: () {
        if (controller.imageList.every((rx) => rx.value != null)) {
          List<Rx<Uint8List>> images = controller.imageList
              .map((rx) => Rx<Uint8List>(rx.value!))
              .toList();
          Get.to(PatientUploadView(photoList: images));
        } else {
          if (!(controller.speechService.isPlaying.value)) {
            controller.speechService.speak(
                "Fotoğraf çekimlerini tamamlamadan sonraki sayfaya geçemezsiniz!");
          }
        }
      },
      child: Container(
        height: SizeConfig.responsiveHeight(75),
        width: SizeConfig.responsiveWidth(150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF90A8C3), width: 4),
        ),
        child: const Center(
            child: Text(
          "Sonraki sayfa",
          style: TextStyle(
              color: Color(0xFF90A8C3),
              fontSize: 16,
              fontWeight: FontWeight.w700),
        )),
      ),
    );
  }

  InkWell button(CameraViewModel controller, CameraDescription camera) {
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
          controller.tryAgain();
        }
      },
      child: Container(
        height: SizeConfig.responsiveHeight(75), //75,
        width: SizeConfig.responsiveHeight(75), //75,
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
    );
  }

  Widget images(CameraViewModel controller) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: SizeConfig.responsiveHeight(100), //70,
          width: SizeConfig.responsiveWidth(360), //310,
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
