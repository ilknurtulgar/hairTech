import 'package:flutter/material.dart';
import 'package:hairtech/core/base/service/database_service.dart';
import 'package:hairtech/model/user_model.dart';

class UserProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  /// Fetches user data from Firestore and notifies the app
  Future<void> fetchUserData(String uid) async {
    // Don't refetch if user is already loaded
    if (_user != null && _user!.uid == uid) return;

    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await _db.getUserData(uid);
    } catch (e) {
      print("Error fetching user data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clears user data on logout
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}