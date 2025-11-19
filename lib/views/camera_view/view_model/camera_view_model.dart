// ignore_for_file: unused_field, avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image/image.dart' as img;

import '../../../core/image/converter/image_converter.dart';
import '../../../product/enum/head_pose.dart';
import '../../../product/message/show/show_messages.dart';
import '../../../product/message/util/command_message.dart';
import '../../../product/service/command_service.dart';
import '../../../product/service/distance_service.dart';
import '../../../product/service/pose_detector_service.dart';
import '../../../product/service/sensor_service.dart';
import '../../../product/service/tts_service.dart';

class CameraViewModel extends GetxController {
  // Service
  late SensorService sensorService;
  late DistanceService distanceService;
  late SpeechService speechService;
  late CommandService commandService;
  late PoseDetectorService poseDetectorService;

  // Camera
  final RxBool _isInitialized = RxBool(false);
  late CameraController _cameraController;
  late CameraImage _cameraImage;
  late CameraDescription cameraDescription;

  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;

  // Face detector
  late FaceDetectorOptions options;
  late FaceDetector faceDetector;

  // Pose detector
  late PoseDetector poseDetector;

  // Processing variables
  int frameCount = 0;
  bool isProcessing = false;
  bool isStreaming = false;
  bool isTryingAgain = false;

  RxBool isSpeakingInStream = RxBool(false);
  RxBool isTakingPicture = RxBool(false);

  // Timer
  Timer timer = Timer(Duration.zero, () {});

  // Pose
  int poseIndex = 0;
  final Rx<HeadPose> _currentPose = (HeadPose.front).obs;
  List<HeadPose> poses = HeadPose.values;
  RxString command = ("Başlangıç komutu").obs;
  String lastCommand = "";

  Rx<HeadPose> get currentPose => _currentPose;

  // Photos
  RxList<Rx<Uint8List?>> _imageList = RxList.generate(
    HeadPose.values.length,
    (_) => Rx<Uint8List?>(null),
  );
  List<bool> isTaken = List.filled(HeadPose.values.length, false);

  List<Rx<Uint8List?>> get imageList => _imageList;

  // Face angle values
  Rx<double?> rotX = (0.0).obs;
  Rx<double?> rotY = (0.0).obs;
  Rx<double?> rotZ = (0.0).obs;
  Rx<Rect?> boundingBox = (Rect.fromLTRB(0, 0, 0, 0)).obs;

  RxDouble ratio = 0.0.obs; // Yüz - ekran oranı
  Rx<bool> isInFrame = false.obs;

  List<Rx<double?>> get faceAngles => [rotX, rotY, rotZ];

  // Phone slope values
  RxDouble pitch = (0.0).obs; // Telefon eğimi
  RxDouble roll = (0.0).obs; // Telefon sol sağ eğim

  List<Rx<double?>> get currentPhoneAngles => [roll, pitch];

  // Phone distance
  final RxDouble _distance = (0.0).obs; // Yüzün telefondan cm şeklinde uzaklığı
  Rx<double> get distance => _distance;

  // Omuz
  List<Rx<double?>> _shoulderCoordinates = [];
  final RxDouble _shoulderDistance = (0.0).obs;
  List<Rx<double?>> get shoulderCoordinates => _shoulderCoordinates;
  RxDouble get shoulderDistance => _shoulderDistance;

  // Screen size
  Size _screenSize = Size.zero;
  Size get screenSize => _screenSize;

  @override
  void onInit() {
    // Face detector
    options = FaceDetectorOptions(
      enableContours: false,
      enableClassification: false,
      enableLandmarks: false,
      enableTracking: true,
      minFaceSize: 0.1,
    );
    faceDetector = FaceDetector(options: options);

    // PoseDetector
    final PoseDetector poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        model: PoseDetectionModel.base, // 'base' modeli hızlıdır
        mode: PoseDetectionMode.stream, // Canlı video akışı için
      ),
    );

    // Service
    sensorService = SensorService();
    distanceService = DistanceService();
    speechService = SpeechService();
    poseDetectorService = PoseDetectorService(poseDetector: poseDetector);

    // TTS'i async başlat:
    Future.microtask(() async {
      await speechService.initTts();
    });

    // Sensör akışı
    sensorService.orientationStream.listen((data) {
      pitch.value = data.pitch;
      roll.value = data.roll;
      // anlık güncelleme
      updateCommandService();
    });

    commandService = CommandService(
      currentHeadPose: currentPose,
      currentPhoneAngles: currentPhoneAngles,
      currentPhoneDistance: distance,
      currentFaceAngles: faceAngles,
      currentShoulderCoordinates: shoulderCoordinates,
      screenSize: screenSize,
      currentShoulderDistance: shoulderDistance,
    );

    super.onInit();
  }

  @override
  void dispose() {
    if (_cameraController.value.isInitialized &&
        _cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
    }
    _cameraController.dispose();
    faceDetector.close();
    // pose detector close
    // sensor close
    speechService.disposeService();
    super.dispose();
  }

  void tryAgain() {
    // Pose
    poseIndex = 0;
    currentPose.value = HeadPose.front;
    command.value = "Başlangıç komutu";
    lastCommand = "";

    // Photos
    _imageList = RxList.generate(
      HeadPose.values.length,
      (_) => Rx<Uint8List?>(null),
    );
    isTaken = List.filled(HeadPose.values.length, false);

    if (timer.isActive) timer.cancel();

    startCountdown();
  }

  Future<void> startCountdown() async {
    // İlk mesaj
    await speechService.speak(CommandMessage.startingCountDown);

    // Geri sayım
    for (int i = 3; i >= 1; i--) {
      await speechService.speak("$i");
      await Future.delayed(
        const Duration(seconds: 1),
      );
    }

    // ilk komut anlık
    checkCommandAfterTTS();

    // Timer'ı başlat
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => checkCommandAfterTTS(),
    );
  }

  void checkCommandAfterTTS() {
    command.value = commandService.getCommand();

    if (command.value != CommandMessage.empty &&
        command.value != lastCommand &&
        !isSpeakingInStream.value) {
      lastCommand = command.value;

      if (!speechService.isPlaying.value) {
        if (poseIndex < HeadPose.values.length) {
          speechService.speak(command.value);
        }
      }
    }
  }

  void cleanParameters() {
    // Pose
    poseIndex = 0;
    currentPose.value = HeadPose.front;
    command.value = "Başlangıç komutu";
    lastCommand = "";

    // Photos
    _imageList = RxList.generate(
      HeadPose.values.length,
      (_) => Rx<Uint8List?>(null),
    );
    isTaken = List.filled(HeadPose.values.length, false);

    // Face angle values
    rotX = (0.0).obs;
    rotY = (0.0).obs;
    rotZ = (0.0).obs;
    boundingBox = (const Rect.fromLTRB(0, 0, 0, 0)).obs;

    ratio = (0.0).obs;
    isInFrame.value = false;

    // Phone slope values
    pitch.value = 0.0;
    roll.value = 0.0;

    // Phone distance
    distance.value = 0.0;

    _shoulderCoordinates = [];
  }

  void updateCommandService() {
    commandService.currentPhoneDistance = distance;
    commandService.currentPhoneAngles = currentPhoneAngles;
    commandService.currentFaceAngles = faceAngles;
    commandService.currentShoulderCoordinates = shoulderCoordinates;
    commandService.screenSize = screenSize;
    commandService.currentShoulderDistance = shoulderDistance;
    commandService.currentHeadPose = currentPose;
  }

  Future<void> initCamera(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      imageFormatGroup:
          Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.nv21,
    );

    // If the controller is updated then update the UI.
    _cameraController.addListener(() {
      if (cameraController.value.hasError) {
        ShowMessages.showInSnackBar(
          'Camera error ${cameraController.value.errorDescription}',
        );
      }
    });

    await _cameraController.initialize().then((_) {
      _isInitialized.value = true;
      _screenSize = cameraController.value.previewSize ?? Size.zero;
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            ShowMessages.showInSnackBar('You have denied camera access.');
          case 'CameraAccessDeniedWithoutPrompt':
            // iOS only
            ShowMessages.showInSnackBar(
              'Please go to Settings app to enable camera access.',
            );
          case 'CameraAccessRestricted':
            // iOS only
            ShowMessages.showInSnackBar('Camera access is restricted.');
          case 'AudioAccessDenied':
            ShowMessages.showInSnackBar('You have denied audio access.');
          case 'AudioAccessDeniedWithoutPrompt':
            // iOS only
            ShowMessages.showInSnackBar(
              'Please go to Settings app to enable audio access.',
            );
          case 'AudioAccessRestricted':
            // iOS only
            ShowMessages.showInSnackBar('Audio access is restricted.');
          default:
            _showCameraException(e);
        }
      }
    });
  }

  Future<void> streamImage(CameraDescription camera, CameraImage image) async {
    if (isProcessing) return;
    isProcessing = true;
    _cameraImage = image;
    // Her 5. frame’de bir çalış
    if (frameCount++ % 5 == 0) {
      final inputImage = _inputImageFromCameraImage(image, camera);
      if (inputImage != null) {
        try {
          await _processImage(inputImage);
          // Omuz koordinatlarını al
          List<double> coordinates =
              await poseDetectorService.getShoulderCoordinates(inputImage);
          _shoulderCoordinates =
              coordinates.map((coord) => Rx<double?>(coord)).toList();
          _shoulderDistance.value =
              await poseDetectorService.getShoulderDistance(inputImage);

          // CommandService verilerini önce güncelle
          updateCommandService();
          if (command.value ==
                  CommandMessage.empty
              &&
              !isTaken[poseIndex] &&
              poseIndex < HeadPose.values.length &&
              !isTakingPicture.value) {
            isSpeakingInStream.value = true;
            if (!speechService.isPlaying.value) {
              speechService.speak(CommandMessage.photoShooting);
            }
            isTakingPicture.value = true;
            await capture();
            isTakingPicture.value = false;
            isTaken[poseIndex] = true;
            poseIndex++;
            if (poseIndex < poses.length) {
              _currentPose.value = poses[poseIndex];
              command.value =
                  "Sonraki çekim ${currentPose.value.name}, ${currentPose.value.firstCommand}"; //currentPose.value.firstCommand;
              await Future.delayed(const Duration(seconds: 1));
              if (!speechService.isPlaying.value) {
                speechService.speak(command.value);
              }
            } else {
              await Future.delayed(const Duration(seconds: 1));
              if (!speechService.isPlaying.value) {
                speechService.speak(CommandMessage.photoEnd);
              }
              if (timer.isActive) {
                timer.cancel();
              }
            }
            await Future.delayed(const Duration(seconds: 3), () { //
              isSpeakingInStream.value = false;
            });
          }
        } catch (e) {
          print("ML processing error: $e");
        }
      }
    }
    isProcessing = false; // yeri değişebilir üst satıra
  }

  void _showCameraException(CameraException e) {
    ShowMessages.logError(e.code, e.description);
    ShowMessages.showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );

      // Dönüş açısını belirle
      final rotation = InputImageRotationValue.fromRawValue(
        camera.sensorOrientation,
      );
      if (rotation == null) return null;

      // Platforma göre formatı belirle
      final format =
          Platform.isIOS ? InputImageFormat.bgra8888 : InputImageFormat.nv21;

      // Metadata oluştur
      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      // InputImage oluştur ve döndür
      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      print('InputImage dönüşüm hatası: $e');
      return null;
    }
  }

  Future _processImage(InputImage inputImage) async {
    final List<Face> faces = await faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      final face = faces.first;
      boundingBox.value = face.boundingBox;
      
      isInFrame.value = true;

      // Pitch (Sapma)
      rotX.value =
          face.headEulerAngleX; // Head is tilted up and down rotX degrees
      // Yaw (Eğim)
      rotY.value =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      // Roll (yalpalama)
      rotZ.value = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
      // Yüz - ekran oranı
      ratio.value = distanceService.calculateRatio(
        face,
        inputImage.metadata!.size.width,
      );
      // Yüzün ekrandan uzaklığı cm cinsinden
      _distance.value = distanceService.calculateDistanceCm(ratio.value);
    }
  }

  Future<void> capture() async {
    final CameraController cameraController = _cameraController;

    if (!cameraController.value.isInitialized) {
      ShowMessages.showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isTakingPicture) {
      // Halihazırda fotoğraf çekiliyorsa bekle
      return;
    }

    final image = _cameraImage;
    final int sensorOrientation =
        cameraController.description.sensorOrientation;

    Uint8List? jpeg;

    try {
      if (image.format.group == ImageFormatGroup.bgra8888) {
        // Tek plane, BGRA8888 formatı
        final yBytes = image.planes[0].bytes;
        final params = {
          'bytes': yBytes,
          'width': image.width,
          'height': image.height,
          'sensorOrientation': sensorOrientation,
          'format': 'bgra8888',
        };
        jpeg = await compute(
          ImageConverter.convertBgra8888ToJpegIsolate,
          params,
        );
      } else if (image.format.group == ImageFormatGroup.nv21) {
        // Sadece Y plane var, UV interleaved plane yok
        print("Uyarı: UV plane yok, NV21 fallback uygulanacak");
        // Y plane’den grayscale bir jpeg oluşturabilir veya hiç işlem yapmayabilirsin
        final params = {
          'bytes': image.planes[0].bytes, // tek NV21 buffer!
          'width': image.width,
          'height': image.height,
          'sensorOrientation': sensorOrientation,
        };
        jpeg = await compute(ImageConverter.convertNV21ToJpegIsolate, params);
      } else {
        print("Desteklenmeyen image format: ${image.format.group}");
        return;
      }

      if (jpeg != null) {
        // İşlenmiş JPEG üzerinde post-rotate
        final rotationAngle = currentPose.value == HeadPose.nape ? 180 : 0;

        if (rotationAngle != 0) {
          final decoded = img.decodeImage(jpeg);
          if (decoded != null) {
            final rotated = img.copyRotate(decoded, angle: rotationAngle);
            jpeg = img.encodeJpg(rotated);
          }
        }

        _imageList[poseIndex].value = jpeg;
        _imageList.refresh();
        print("Fotoğraf çekildi, toplam: ${_imageList.length}");
      }
    } catch (e) {
      print("Fotoğraf çekerken hata: $e");
    }
  }

  /*
  // ilk
  Offset scalePosition(double x, double y, Size imageSize, Size widgetSize) {
    double scaleX = widgetSize.width / imageSize.width;
    double scaleY = widgetSize.height / imageSize.height;

    return Offset(x * scaleX, y * scaleY);
  }
  */

  Offset scalePosition(
    double x,
    double y,
    Size imageSize,
    Size widgetSize,
    bool isFrontCamera,
  ) {
    double scaleX = widgetSize.width / imageSize.width;
    double scaleY = widgetSize.height / imageSize.height;

    double scaledX = x * scaleX;

    if (isFrontCamera) {
      // AYNALAMA DÜZELTMESİ
      scaledX = widgetSize.width - scaledX;
    }

    return Offset(scaledX, y * scaleY);
  }

  Future<void> scaleShoulderPosition(InputImage inputImage) async {
    // MLKit image size
    final Size imageSize = Size(
      inputImage.metadata!.size.width,
      inputImage.metadata!.size.height,
    );

    // Omuz koordinatlarını al
    List<double> coordinates = await poseDetectorService.getShoulderCoordinates(
      inputImage,
    );

    // Scaled liste
    List<Rx<double?>> scaled = [];

    // LEFT shoulder (x = 0, y = 1)
    Offset leftScaled = scalePosition(
      coordinates[0], // left X
      coordinates[1], // left Y
      imageSize,
      screenSize,
      true,
    );
    scaled.add(Rx<double?>(leftScaled.dx));
    scaled.add(Rx<double?>(leftScaled.dy));

    // RIGHT shoulder (x = 2, y = 3)
    Offset rightScaled = scalePosition(
      coordinates[2], // right X
      coordinates[3], // right Y
      imageSize,
      screenSize,
      true,
    );
    scaled.add(Rx<double?>(rightScaled.dx));
    scaled.add(Rx<double?>(rightScaled.dy));

    _shoulderCoordinates = scaled;
  }
}
