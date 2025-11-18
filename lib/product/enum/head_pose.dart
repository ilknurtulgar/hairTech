

import '../message/util/command_message.dart';

enum HeadPose { front, left, right, top, nape }

extension HeadPoseExtension on HeadPose {
  String get name {
    switch (this) {
      case HeadPose.left:
        return "Sol yan çekimi";
      case HeadPose.right:
        return "Sağ yan çekimi";
      case HeadPose.top:
        return "Tepe çekimi";
      case HeadPose.nape:
        return "Ense çekimi";
      default:
        return "Önden çekim";
    }
  }
  String get shortName {
switch (this) {
      case HeadPose.left:
        return "Sol";
      case HeadPose.right:
        return "Sağ";
      case HeadPose.top:
        return "Tepe";
      case HeadPose.nape:
        return "Ense";
      default:
        return "Ön";
    }
  }

  // Face angles
  double get suitableAngle {
    switch (this) {
      case HeadPose.left:
        return 45;
      case HeadPose.right:
        return -45;
      case HeadPose.top:
        return -20;
      case HeadPose.nape:
        return 20;
      default:
        return 0;
    }
  }

  List<double> get suitableAngles {
    switch (this) {
      case HeadPose.left:
        return [0, 45, 0];
      case HeadPose.right:
        return [0, -45, 0];
      case HeadPose.top:
        return [-20, 0, 0];
      case HeadPose.nape:
        return [20, 0, 0];
      default:
        return [0, 0, 0];
    }
  }

  int get angleIndex {
    int index = 0; // Tepe ve ense X ekseni
    // Sol ve sağ Y ekseni
    if (this == HeadPose.left || this == HeadPose.right) {
      index = 1;
    }
    return index;
  }

  double get angleTolerance => 5; // Ana eksen için açı toleransı

  bool isAngleSuitable(double? angle) {
    return angleDiff(angle).abs() <= angleTolerance;
  }

  double angleDiff(double? angle) {
    return angle! - suitableAngles[angleIndex];
  }

  // Phone slope
  double get phonePitch {
    if (this == HeadPose.top) return 5; // 0
    if (this == HeadPose.nape) return -30;
    return 90;
  }

  double get phoneRoll => 0;

  // Phone distance
  double get phoneDistance {
    if (this == HeadPose.top || this == HeadPose.nape) return 30;
    return 25;
  }

  double get distanceTolerance => 5;

  // First Command
  String get firstCommand {
    switch (this) {
      case HeadPose.left:
        return CommandMessage.firstLeft;
      case HeadPose.right:
        return CommandMessage.firstRight;
      case HeadPose.top:
        return CommandMessage.firstTop;
      case HeadPose.nape:
        return CommandMessage.firstNape;
      default:
        return CommandMessage.empty;
    }
  }
}
