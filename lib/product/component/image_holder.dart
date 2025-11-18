// ignore_for_file: must_be_immutable

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import '../enum/head_pose.dart';

class ImageHolder extends StatelessWidget {
  Uint8List? image;
  HeadPose headPose;
  ImageHolder({super.key, required this.image, required this.headPose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.responsiveHeight(60),//60,
      width: SizeConfig.responsiveWidth(40),//40,
      decoration: BoxDecoration(
        color: const Color(0xFF90A8C3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(image!, fit: BoxFit.cover),
            )
          : Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(headPose.shortName,style: const TextStyle(color: Colors.white),),
                  const SizedBox(height: 5),
                  const Icon(Icons.photo_camera_outlined, color: Colors.white,size: 18,),
                ],
              ),
          ),
    );
  }
}
