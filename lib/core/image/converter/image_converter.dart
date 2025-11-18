import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageConverter {
  // Without Image
  static Uint8List convertYUV420ToJpegIsolate(Map<String, dynamic> params) {
    final Uint8List yBytes = params['yBytes'];
    final Uint8List uBytes = params['uBytes'];
    final Uint8List vBytes = params['vBytes'];
    final int width = params['width'];
    final int height = params['height'];
    final int sensorOrientation = params['sensorOrientation'];
    final int uvRowStride = params['uvRowStride'];
    final int uvPixelStride = params['uvPixelStride'];

    final img.Image imgBuffer = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = (y >> 1) * uvRowStride + (x >> 1) * uvPixelStride;

        final int Y = yBytes[y * width + x];
        final int U = uBytes[uvIndex];
        final int V = vBytes[uvIndex];

        // YUV -> RGB dönüşümü
        int r = (Y + 1.402 * (V - 128)).clamp(0, 255).toInt();
        int g = (Y - 0.344136 * (U - 128) - 0.714136 * (V - 128))
            .clamp(0, 255)
            .toInt();
        int b = (Y + 1.772 * (U - 128)).clamp(0, 255).toInt();

        imgBuffer.setPixelRgb(x, y, r, g, b);
      }
    }

    img.Image rotated = img.copyRotate(imgBuffer, angle: sensorOrientation);
    rotated = img.flipHorizontal(rotated);

    return Uint8List.fromList(img.encodeJpg(rotated));
  }

  // With Image
  static Uint8List convertYUV420ToJpeg(
    CameraImage image,
    int sensorOrientation,
  ) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    final img.Image imgBuffer = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      final int uvRow = uvRowStride * (y >> 1);
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvRow + (x >> 1) * uvPixelStride;
        final int indexY = y * image.planes[0].bytesPerRow + x;
        final int yp = image.planes[0].bytes[indexY];

        final int up = image.planes[1].bytes[uvIndex];
        final int vp = image.planes[2].bytes[uvIndex];

        int r = (yp + vp * 1436 / 1024 - 179).clamp(0, 255).toInt();
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .clamp(0, 255)
            .toInt();
        int b = (yp + up * 1814 / 1024 - 227).clamp(0, 255).toInt();

        imgBuffer.setPixelRgb(x, y, r, g, b);
      }
    }
    // Rotate image
    img.Image rotated = img.copyRotate(imgBuffer, angle: sensorOrientation);
    rotated = img.flipHorizontal(rotated);

    return Uint8List.fromList(img.encodeJpg(rotated));
  }

  static Uint8List convertBgra8888ToJpegIsolate(Map<String, dynamic> params) {
    final Uint8List bytes = params['bytes'];
    final int width = params['width'];
    final int height = params['height'];
    final int sensorOrientation = params['sensorOrientation'];

    final img.Image imgBuffer = img.Image(width: width, height: height);

    int byteIndex = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int b = bytes[byteIndex++];
        int g = bytes[byteIndex++];
        int r = bytes[byteIndex++];
        byteIndex++; // alpha
        imgBuffer.setPixelRgb(x, y, r, g, b);
      }
    }

    // Rotate ve flip
    img.Image rotated = img.copyRotate(imgBuffer, angle: sensorOrientation);
    rotated = img.flipHorizontal(rotated);

    return Uint8List.fromList(img.encodeJpg(rotated));
  }

  static Map<String, dynamic> prepareNV21Params(
    CameraImage image,
    int sensorOrientation,
  ) {
    // NV21 için tek plane yok, Flutter CameraImage'da NV21 tek plane olarak geliyor
    final Uint8List yBytes = image.planes[0].bytes; // Y + interleaved VU
    final int width = image.width;
    final int height = image.height;

    // NV21’de VU interleaved, plane bilgisi yoksa row/pixel stride varsayılan
    final int uvRowStride = width;
    final int uvPixelStride = 2; // V ve U arka arkaya geliyor

    return {
      'yBytes': yBytes,
      'uvBytes': yBytes, // NV21’de tek buffer: Y + interleaved VU
      'width': width,
      'height': height,
      'sensorOrientation': sensorOrientation,
      'uvRowStride': uvRowStride,
      'uvPixelStride': uvPixelStride,
    };
  }

  static Uint8List convertNV21ToJpegIsolate(Map<String, dynamic> params) {
    final Uint8List bytes = params['bytes']; // Tek buffer NV21
    final int width = params['width'];
    final int height = params['height'];
    final int sensorOrientation = params['sensorOrientation'];

    final img.Image imgBuffer = img.Image(width: width, height: height);

    final int frameSize = width * height;
    final int uvStart = frameSize; // VU buradan başlıyor

    for (int y = 0; y < height; y++) {
      final int uvRow = (y >> 1) * width;
      for (int x = 0; x < width; x++) {
        final int yIndex = y * width + x;

        final int uvIndex = uvStart + uvRow + (x & ~1);

        final int Y = bytes[yIndex] & 0xFF;
        final int V = bytes[uvIndex] & 0xFF;
        final int U = bytes[uvIndex + 1] & 0xFF;

        int r = (Y + 1.402 * (V - 128)).clamp(0, 255).toInt();
        int g = (Y - 0.344136 * (U - 128) - 0.714136 * (V - 128))
            .clamp(0, 255)
            .toInt();
        int b = (Y + 1.772 * (U - 128)).clamp(0, 255).toInt();

        imgBuffer.setPixelRgb(x, y, r, g, b);
      }
    }

    img.Image rotated = img.copyRotate(imgBuffer, angle: sensorOrientation);
    rotated = img.flipHorizontal(rotated);

    return Uint8List.fromList(img.encodeJpg(rotated));
  }
}
