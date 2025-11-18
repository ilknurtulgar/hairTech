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
    // 1. Don't re-fetch if we already have the right user
    if (_user != null && _user!.uid == uid) return;

    // 2. Don't re-fetch if we are already loading
    if (_isLoading) return;

    _isLoading = true;
    
    // 3. THIS IS THE FIX:
    // We must notify *after* the current build frame is done.
    // This safely tells the UI "I am now loading"
    // without causing the "setState during build" error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    
    try {
      _user = await _db.getUserData(uid);
    } catch (e) {
      print("Error fetching user data: $e");
    }

    _isLoading = false;
    notifyListeners(); // This one is fine, it happens after 'await'
  }

  /// Clears user data on logout
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}