

import '../message/util/command_message.dart';

enum PhoneSlope { roll, pitch }

extension PhoneSlopeExtension on PhoneSlope {
  String get positiveCommand {
    if (this == PhoneSlope.pitch) return CommandMessage.phoneUp;
    return CommandMessage.phoneRight;
  }

  String get negativeCommand {
    if (this == PhoneSlope.pitch) return CommandMessage.phoneDown;
    return CommandMessage.phoneLeft;
  }

  double get tolerance {
    if (this == PhoneSlope.roll) return 50; // Roll pitch 90 iken çok fazla değişiyor.
    return 10;
  }

  double get mainTolerance => 2;

  int get index => this == PhoneSlope.pitch ? 1 : 0;
}
