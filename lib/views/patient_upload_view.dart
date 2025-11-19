import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/components/button.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/core/base/service/storage_service.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:hairtech/views/main_navigation_view.dart';
import 'package:hairtech/views/patient_home_view.dart';
import 'package:image_picker/image_picker.dart';

import '../product/component/image_holder.dart';
import '../product/enum/head_pose.dart';

class PatientUploadView extends StatelessWidget {
  List<Rx<Uint8List>> photoList;
  PatientUploadView({super.key, required this.photoList});

  @override
  Widget build(BuildContext context) {
    final StorageService storageService = Get.find<StorageService>();
    final DatabaseService databaseService = Get.find<DatabaseService>();
    final UserController userController = Get.find<UserController>();
    final noteController = TextEditingController();

    final selectedImages = <XFile>[].obs;
    final isLoading = false.obs;
    final errorMessage = Rx<String?>(null);

    Future<void> pickImages() async {
      final List<XFile> images = await storageService.pickImages();
      if (images.isNotEmpty) {
        selectedImages.value = images;
        errorMessage.value = null;
      }
    }

    Future<void> handleSubmit() async {
      FocusScope.of(context).unfocus();
      final user = userController.user;
      if (user == null) return;

      if (photoList.length != 5) {
        errorMessage.value = ConstTexts.errorMinPhotos;
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;

      try {
        // Rx<Uint8List?> → Uint8List listesi
        List<Uint8List> _photoList =
            photoList.map((rxBytes) => rxBytes.value!).toList();

        // Firebase upload
        final List<String> imageURLs =
            await storageService.uploadUint8Images(
          user.uid,
          _photoList,
        );

        if (imageURLs.isEmpty) {
          throw Exception("Görseller yüklenemedi.");
        }

        // Database kaydı
        await databaseService.addPatientUpdate(
          patientUid: user.uid,
          patientNote: noteController.text.trim(),
          imageURLs: imageURLs,
        );

        print(ConstTexts.successUpload);
        Get.to(() => const MainNavigationView()); // sayfa kapat
      } catch (e) {
        errorMessage.value = e.toString();
        print("Hata: $e");
      } finally {
        isLoading.value = false; // her durumda loading kapansın
      }
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
        title: Text(
          ConstTexts.uploadHeader,
          style: TextUtility.getStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: ResponsePadding.page(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*
            Button(
              text: ConstTexts.uploadButton,
              onTap: pickImages,
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
            ), */
            const SizedBox(height: 16),
            //Obx(() => _buildImageGrid(selectedImages.value)),
            _photoListView(),
            const SizedBox(height: 24),
            _buildNoteInput(noteController),
            const SizedBox(height: 24),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (errorMessage.value != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          errorMessage.value!,
                          style: TextUtility.getStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Button(
                      text: ConstTexts.submitButton,
                      onTap: handleSubmit,
                      isLoading: isLoading.value,
                      backgroundColor: AppColors.green,
                      textColor: AppColors.white,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _photoListView() {
    return Obx(() {
      return Row(
        children: List.generate(photoList.length, (index) {
          final img = photoList[index];
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ImageHolder(
              image: img.value,
              headPose: HeadPose.values[index],
            ),
          );
        }),
      );
    });
  }

  Widget _buildNoteInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 8,
      style: TextUtility.getStyle(color: AppColors.dark),
      decoration: InputDecoration(
        hintText: ConstTexts.uploadNoteHint,
        hintStyle: TextUtility.getStyle(
          color: AppColors.darkgray,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColors.lightgray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<XFile> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final image = images[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildPlatformSpecificImage(image),
        );
      },
    );
  }

  Widget _buildPlatformSpecificImage(XFile image) {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: image.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return Container(
            color: AppColors.lightgray,
            child: const Icon(Icons.image, color: AppColors.darkgray),
          );
        },
      );
    } else {
      return Image.file(File(image.path), fit: BoxFit.cover);
    }
  }
}
