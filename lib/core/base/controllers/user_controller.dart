import 'package:get/get.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/model/user_model.dart';

// REPLACES UserProvider
class UserController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();

  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;

  UserModel? get user => _user.value;
  bool get isLoading => _isLoading.value;

  Future<void> fetchUserData(String uid) async {
    if (_user.value != null && _user.value!.uid == uid) return;
    if (_isLoading.value) return;

    _isLoading.value = true;
    _user.value = await _db.getUserData(uid);
    _isLoading.value = false;
  }

  void setUser(UserModel userData) {
    _user.value = userData;
  }

  void clearUser() {
    _user.value = null;
  }
}