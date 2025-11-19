import 'dart:io';

import 'package:camera/camera.dart';

import '../message/show/show_messages.dart';

class CameraService {
  Future<CameraDescription?> _getCamera() async {
    try {
      final cameras = await availableCameras();
      return cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } on CameraException catch (e) {
      ShowMessages.logError(e.code, e.description);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    ShowMessages.logError(e.code, e.description);
    ShowMessages.showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _handleCameraException(Object e) {
    if (e is CameraException) {
      switch (e.code) {
        case 'CameraAccessDenied':
          ShowMessages.showInSnackBar('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          ShowMessages.showInSnackBar(
            'Please go to Settings app to enable camera access.',
          );
        case 'CameraAccessRestricted':
          // iOS only
          ShowMessages.showInSnackBar('Camera access is restricted.');
        case 'AudioAccessDenied':
          ShowMessages.showInSnackBar('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          ShowMessages.showInSnackBar(
            'Please go to Settings app to enable audio access.',
          );
        case 'AudioAccessRestricted':
          // iOS only
          ShowMessages.showInSnackBar('Audio access is restricted.');
        default:
          _showCameraException(e);
      }
    }
  }

  Future<CameraController?> initCameraController() async {
    CameraDescription? frontCamera = await _getCamera();
    if (frontCamera == null) return null;

    final cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      imageFormatGroup: Platform.isIOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.nv21,
    );

    cameraController.addListener(() {
      if (cameraController.value.hasError) {
        ShowMessages.showInSnackBar(
          'Camera error ${cameraController.value.errorDescription}',
        );
      }
    });

    try {
      await cameraController.initialize();
    } catch (e) {
      _handleCameraException(e);
      return null;
    }

    return cameraController;
  }

  Future<Map<String, dynamic>?> initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.nv21,
      );

      await controller.initialize();

      return {
        'camera': frontCamera,
        'controller': controller,
      };
    } catch (e) {
      print('Camera init error: $e');
      return null;
    }
  }
}