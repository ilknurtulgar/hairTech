import 'package:get/get.dart';

class ShowMessages {
  static void showInSnackBar(String message) {
    Get.snackbar("Error", message);
  }

  static void logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }
  
}