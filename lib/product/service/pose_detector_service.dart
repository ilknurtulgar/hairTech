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
}
