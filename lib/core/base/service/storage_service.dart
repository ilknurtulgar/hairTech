import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // <-- 1. Import kIsWeb

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick multiple images from the gallery
  Future<List<XFile>> pickImages() async {
    // You can pick multiple images, but we'll limit it to 5 in the UI
    final List<XFile> images = await _imagePicker.pickMultiImage(
      imageQuality: 80, // Compress images
    );
    return images;
  }

  /// Upload a list of images and return their download URLs
  Future<List<String>> uploadImages(String patientUid, List<XFile> images) async {
    try {
      List<String> downloadUrls = [];

      // Use Future.wait to upload all images in parallel
      await Future.wait(images.map((image) async {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}-${image.name}';
        final Reference ref = _storage
            .ref()
            .child('patient_updates')
            .child(patientUid)
            .child(fileName);

        // --- 2. THIS IS THE FIX ---
        if (kIsWeb) {
          // Use putData for web
          final uploadTask = ref.putData(await image.readAsBytes());
          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        } else {
          // Use putFile for mobile
          final uploadTask = ref.putFile(File(image.path));
          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }
      }));

      return downloadUrls;
    } catch (e) {
      print("Error uploading images: $e");
      throw Exception("Görsel yükleme hatası: $e");
    }
  }
}