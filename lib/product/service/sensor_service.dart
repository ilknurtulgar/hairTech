import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  /// Pitch (telefonu öne eğme - X ekseni)
  double pitch = 0;

  /// Roll (telefonu sağ/sol eğme - Y ekseni)
  double roll = 0;

  /// Stream: pitch & roll değerleri akar
  late final Stream<SensorOrientation> orientationStream;

  SensorService() {
    orientationStream = _createStream();
  }

  Stream<SensorOrientation> _createStream() {
    return accelerometerEventStream().map((event) {
      final px = atan2(event.y, sqrt(event.x * event.x + event.z * event.z));
      final rl = atan2(-event.x, event.z);

      final pitchDeg = px * 180 / pi;
      final rollDeg = rl * 180 / pi;

      return SensorOrientation(
        pitch: pitchDeg,
        roll: rollDeg,
      );
    });
  }
}

class SensorOrientation {
  final double pitch;
  final double roll;

  SensorOrientation({
    required this.pitch,
    required this.roll,
  });
}

