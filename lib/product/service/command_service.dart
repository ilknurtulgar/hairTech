import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product/enum/custom_axis.dart';
import '../../product/enum/head_pose.dart';
import '../../product/enum/phone_slope.dart';
import '../message/util/command_message.dart';

class CommandService {
  Rx<HeadPose> currentHeadPose;
  List<Rx<double?>> currentPhoneAngles;
  Rx<double> currentPhoneDistance;
  List<Rx<double?>> currentFaceAngles;
  List<Rx<double?>> currentShoulderCoordinates;
  Size screenSize;

  //Rx<Size?> currentImageSize;
  //Rx<Size?> currentPreviewSize;
  //Rx<Rect?> currentBoundingBox;

  CommandService({
    required this.currentHeadPose,
    required this.currentPhoneAngles,
    required this.currentPhoneDistance,
    required this.currentFaceAngles,
    required this.currentShoulderCoordinates,
    required this.screenSize,
    //required this.currentImageSize,
    //required this.currentPreviewSize,
    //required this.currentBoundingBox,
  });

  // Command
  // 1) Telefon eğikliği // Hallettim.
  // 2) Telefon uzaklığı //
  // 3) Yüz kadrajın içinde mi?
  // 4) Açı //

  List<bool> isAngleSuitable = List.filled(CustomAxis.values.length, false);
  List<bool> isSlopeSuitable = List.filled(PhoneSlope.values.length, false);
  bool isDistanceSuitable = false;
  bool isInFrame = false;
  List<bool> isFrameSuitable = List.filled(Frame.values.length, false);
  bool isShoulderSuitable = false;

  bool get isHeadOverShooting =>
      currentHeadPose.value == HeadPose.top ||
      currentHeadPose.value == HeadPose.nape;

  String getCommand() {
    for (var command in Command.values) {
      String commandMessage = CommandMessage.empty;
      switch (command) {
        case Command.slope:
          commandMessage = phoneSlopeCommand();
        case Command.distance:
          if (!isHeadOverShooting) commandMessage = phoneDistanceCommand();
        case Command.angle:
          if (!isHeadOverShooting) commandMessage = faceAngleCommand();
        case Command.frame:
          if (isHeadOverShooting) commandMessage = shoulderCheck();
      }
      if (commandMessage != CommandMessage.empty) return commandMessage;
    }
    return CommandMessage.empty;
  }

  bool get isEverythingSuitable => faceAngleCheck();
  //honeSlopeCheck() && phoneDistanceCheck() && faceAngleCheck();

  bool phoneSlopeCheck() =>
      isSlopeSuitable == List.filled(PhoneSlope.values.length, true);

  String phoneSlopeCommand() {
    for (var slope in PhoneSlope.values) {
      if (/*isHeadOverShooting && */ slope == PhoneSlope.roll) continue;
      String command = _phoneAngleCheck(slope);
      if (command != CommandMessage.empty) return command;
    }
    return CommandMessage.empty;
  }

  String _phoneAngleCheck(PhoneSlope slope) {
    String command = CommandMessage.empty;
    double? angle = currentPhoneAngles[slope.index].value;
    double tolerance = slope
        .tolerance; //isHeadOverShooting ? slope.mainTolerance : slope.tolerance;
    if (angle != null) {
      double headPoseAngle = slope == PhoneSlope.pitch
          ? currentHeadPose.value.phonePitch
          : currentHeadPose.value.phoneRoll;
      double angleDiff = angle - headPoseAngle;
      if (angleDiff.abs() <= tolerance) {
        isSlopeSuitable[slope.index] = true;
      } else {
        isSlopeSuitable[slope.index] = false;
        if (angleDiff > tolerance) {
          command = slope.negativeCommand;
        } else {
          command = slope.positiveCommand;
        }
      }
    } else {
      isSlopeSuitable[slope.index] = false;
    }
    return command;
  }

  bool phoneDistanceCheck() => isDistanceSuitable;

  String phoneDistanceCommand() {
    String command = CommandMessage.empty;
    double tolerance = currentHeadPose.value.distanceTolerance;
    double distanceDiff =
        currentPhoneDistance.value - currentHeadPose.value.phoneDistance;
    if (distanceDiff.abs() <= tolerance) {
      isDistanceSuitable = true;
    } else {
      isDistanceSuitable = false;
      if (distanceDiff > tolerance) {
        // Telefonu yaklaştır
        command = CommandMessage.getClose;
      } else {
        // Telefonu uzaklaştır
        command = CommandMessage.stayAway;
      }
    }
    return command;
  }

  bool faceAngleCheck() =>
      isAngleSuitable == List.filled(CustomAxis.values.length, true);

  String faceAngleCommand() {
    if (currentHeadPose.value != HeadPose.top &&
        currentHeadPose.value != HeadPose.nape) {
      for (var axis in CustomAxis.values) {
        String command = _axisCheck(
          axis,
          currentHeadPose.value.angleIndex == axis.index,
        );
        if (command != CommandMessage.empty) return command;
      }
    }
    return CommandMessage.empty;
  }

  String _axisCheck(CustomAxis axis, bool isMain) {
    String command = "";
    double? angle = currentFaceAngles[axis.index].value;
    double tolerance = isMain ? axis.mainTolerance : axis.tolerance;

    if (angle != null) {
      double angleDiff = isMain
          ? currentHeadPose.value.angleDiff(angle)
          : (angle - axis.normalBound);
      if (angleDiff.abs() <= tolerance) {
        isAngleSuitable[axis.index] = true;
      } else {
        isAngleSuitable[axis.index] = false;
        if (angleDiff > tolerance) {
          command = axis.negativeCommand;
        } else {
          command = axis.positiveCommand;
        }
      }
    } else {
      isAngleSuitable[axis.index] = false;
    }
    return command;
  }

  String shoulderCheck() {
    String command = CommandMessage.empty;
    if (currentShoulderCoordinates.isNotEmpty) {
      double? leftX = currentShoulderCoordinates[0].value;
      double? rightX = currentShoulderCoordinates[2].value;

      if (leftX != null && rightX != null) {
        final double shoulderCenterX = (leftX + rightX) / 2;
        final double screenCenterX = 350; //screenSize.width / 2;

        final double tolerance = 25; //screenSize.width * 0.15;
        final double positionDiff = shoulderCenterX - screenCenterX;

        if (positionDiff.abs() <= tolerance) {
          isShoulderSuitable = true;
        } else {
          isShoulderSuitable = false;
          if (positionDiff > tolerance) {
            command = CommandMessage.phoneLeftPosition;
          } else {
            command = CommandMessage.phoneRightPosition;
          }
        }
      } else {
        isShoulderSuitable = false;
        //command = CommandMessage.outsideFrame;
      }
    } else {
      isShoulderSuitable = false;
      command = CommandMessage.outsideFrame;
    }
    return command;
  }

  bool frameCheck() =>
      isFrameSuitable == List.filled(Frame.values.length, true);

  Rect _scaleRect({
    required Rect rect,
    required Size imageSize,
    required Size widgetSize,
  }) {
    double scaleX = widgetSize.width / imageSize.width;
    double scaleY = widgetSize.height / imageSize.height;

    return Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );
  }

  // Merkezde olup olmadığının kontrolü
  String frameCommand(Rect? boundingBox, Size? imageSize, Size? previewSize) {
    String command = CommandMessage.empty;
    if (boundingBox != null && imageSize != null && previewSize != null) {
      final rect = boundingBox;

      final Rect scaledBox = _scaleRect(
        rect: rect,
        imageSize: imageSize,
        widgetSize: previewSize,
      );

      // 0.15 - 0.85 yüzde aralığı
      double leftLimit = previewSize.width * 0.15;
      double rightLimit = previewSize.width * 0.85;
      double topLimit = previewSize.height * 0.15;
      double bottomLimit = previewSize.height * 0.85;

      double faceCenterX = (scaledBox.left + scaledBox.right) / 2;
      double faceCenterY = (scaledBox.top + scaledBox.bottom) / 2;

      bool isXCentered = faceCenterX > leftLimit && faceCenterX < rightLimit;
      bool isYCentered = faceCenterY > topLimit && faceCenterY < bottomLimit;

      isInFrame = isXCentered && isYCentered;
      if (!isInFrame) command = CommandMessage.outsideFrame;
    }
    return command;
  }
}

enum Command { slope, distance, frame, angle }

enum Frame { left, top, bottom, right }

extension FrameExtension on Frame {}
