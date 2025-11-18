
import '../message/util/command_message.dart';

enum CustomAxis { X, Y, Z }

extension CustomAxisExtension on CustomAxis {
  String get positiveCommand {
    switch (this) {
      case CustomAxis.X:
        return CommandMessage.headUp;
      case CustomAxis.Y:
        return CommandMessage.headLeft;
      case CustomAxis.Z:
        return CommandMessage.headVerticalRight;
    }
  }

  String get negativeCommand {
    switch (this) {
      case CustomAxis.X:
        return CommandMessage.headDown;
      case CustomAxis.Y:
        return CommandMessage.headRight;
      case CustomAxis.Z:
        return CommandMessage.headVerticalLeft;
    }
  }

  int get index {
    switch (this) {
      case CustomAxis.X:
        return 0;
      case CustomAxis.Y:
        return 1;
      case CustomAxis.Z:
        return 2;
    }
  }

  // Pozisyonda kullanılmayan eksen için gerekli sınır açısı
  double get normalBound => 0;

  double get tolerance => 15; // Ana eksen olmayınca tolerans

  double get mainTolerance => 5; // Ana eksen olunca tolerans
}
