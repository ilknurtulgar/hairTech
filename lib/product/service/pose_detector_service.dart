import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectorService {
  final PoseDetector poseDetector;

  PoseDetectorService({required this.poseDetector});

  Future<List<double>> getShoulderCoordinates(InputImage inputImage) async {
    final List<Pose> poses = await poseDetector.processImage(inputImage);

    if (poses.isEmpty) return List.empty();

    // Genelde ekranda sadece 1 kişi olacağını varsayıyoruz
    final Pose pose = poses.first;
    final Map<PoseLandmarkType, PoseLandmark> landmarks = pose.landmarks;

    final PoseLandmark? leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark? rightShoulder =
        landmarks[PoseLandmarkType.rightShoulder];

    if (leftShoulder == null || rightShoulder == null) return List.empty();

    return [leftShoulder.x, leftShoulder.y, rightShoulder.x, rightShoulder.y];
  }

  Future<double> getShoulderRatio(InputImage inputImage) async {
    if (inputImage.metadata == null) return 0;
    double imageWidth = inputImage.metadata!.size.width;
    List<double> shoulderCoordinates = await getShoulderCoordinates(inputImage);
    if (shoulderCoordinates.isEmpty) return 0;
    double shoulderWidth =
        shoulderCoordinates[0] - shoulderCoordinates[2]; // x konumu
    return shoulderWidth / imageWidth;
  }

  Future<double> getShoulderDistance(InputImage inputImage) async {
    double shoulderRatio = await getShoulderRatio(inputImage);
    if (shoulderRatio == 0) return 0;
    return 9.6 / shoulderRatio; // k = 9.6
  }
}
