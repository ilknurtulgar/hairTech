import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CustomCameraPreview extends StatelessWidget{
  final CameraController cameraController;

  const CustomCameraPreview({
    super.key,
    required this.cameraController
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color:const Color(0xFF90A8C3),width: 4)
      ),
      child: CameraPreview(cameraController),
    );
  }
}
