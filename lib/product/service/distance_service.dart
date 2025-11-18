import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DistanceService {
  // Kalibrasyon sabiti
  final double k;

  DistanceService({this.k = 8.9});

  double calculateDistanceCm(double faceRatio) {
    if (faceRatio <= 0) return 0;
    return k / faceRatio;
  }

  double calculateRatio(Face face, double imageWidth) {
    return face.boundingBox.width / imageWidth;
  }
}
