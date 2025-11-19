import 'package:get/get.dart';
import 'package:hairtech/core/base/controllers/auth_controller.dart';
import 'package:hairtech/core/base/controllers/doctor_home_controller.dart';
import 'package:hairtech/core/base/controllers/patient_home_controller.dart';
import 'package:hairtech/core/base/controllers/user_controller.dart';
import 'package:hairtech/core/base/service/auth_service.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/core/base/service/storage_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(DatabaseService(), permanent: true);
    Get.put(StorageService(), permanent: true);

    Get.put(AuthController(), permanent: true);
    Get.put(UserController(), permanent: true);

    Get.lazyPut(() => PatientHomeController());
    Get.lazyPut(() => DoctorHomeController());
  }
}