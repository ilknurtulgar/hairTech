import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // <-- kIsWeb
import 'dart:typed_data'; // <-- Import this for Uint8List
import 'package:hairtech/core/base/components/button.dart';
import 'package:hairtech/core/base/providers/user_provider.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/core/base/service/storage_service.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/padding_util.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PatientUploadView extends StatefulWidget {
  const PatientUploadView({super.key});

  @override
  State<PatientUploadView> createState() => _PatientUploadViewState();
}

class _PatientUploadViewState extends State<PatientUploadView> {
  final StorageService _storageService = StorageService();
  final DatabaseService _databaseService = DatabaseService();
  final _noteController = TextEditingController();

  List<XFile> _selectedImages = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _storageService.pickImages();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
        _errorMessage = null; // Clear error on new selection
      });
    }
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    final user = context.read<UserProvider>().user;
    if (user == null) return; // Should never happen here

    if (_selectedImages.length != 5) {
      setState(() {
        _errorMessage = ConstTexts.errorMinPhotos;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Upload images to Storage
      final List<String> imageURLs =
          await _storageService.uploadImages(user.uid, _selectedImages);

      if (imageURLs.isEmpty) {
        throw Exception("Görseller yüklenemedi.");
      }

      // 2. Save note and URLs to Firestore
      await _databaseService.addPatientUpdate(
        patientUid: user.uid,
        patientNote: _noteController.text.trim(),
        imageURLs: imageURLs,
      );

      // 3. Success
      if (mounted) {
        // TODO: Show a success snackbar (or alert)
        print(ConstTexts.successUpload);
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.dark),
          onPressed: () => Navigator.of(context).pop(),
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
            Button(
              text: ConstTexts.uploadButton,
              onTap: _pickImages,
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
            ),
            const SizedBox(height: 16),
            _buildImageGrid(),
            const SizedBox(height: 24),
            _buildNoteInput(),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextUtility.getStyle(
                      color: AppColors.secondary, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            Button(
              text: ConstTexts.submitButton,
              onTap: _handleSubmit,
              isLoading: _isLoading,
              backgroundColor: AppColors.green, // Corrected color
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return TextField(
      controller: _noteController,
      maxLines: 8,
      style: TextUtility.getStyle(color: AppColors.dark),
      decoration: InputDecoration(
        hintText: ConstTexts.uploadNoteHint,
        hintStyle: TextUtility.getStyle(
          color: AppColors.darkgray, // Corrected color
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColors.lightgray, // Corrected color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 images per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final image = _selectedImages[index]; // Get the XFile
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildPlatformSpecificImage(image),
        );
      },
    );
  }

  /// Handles showing the image on Web (Memory) vs Mobile (File)
  Widget _buildPlatformSpecificImage(XFile image) {
    if (kIsWeb) {
      // --- FOR WEB ---
      // We must read the bytes and use Image.memory
      return FutureBuilder<Uint8List>(
        future: image.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          // Show a placeholder while loading the image bytes
          return Container(
            color: AppColors.lightgray, // Corrected color
            child: const Icon(Icons.image, color: AppColors.darkgray),
          );
        },
      );
    } else {
      // --- FOR MOBILE ---
      // Image.file is correct
      return Image.file(File(image.path), fit: BoxFit.cover);
    }
  }
}