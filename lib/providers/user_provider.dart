import 'package:flutter/material.dart';
import 'package:streamscape/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void loadUserFromJSON(Map<String, dynamic> json) {
    _user = User.fromJson(json);
    notifyListeners();
  }

  Map<String, dynamic>? toJson() {
    if (_user != null) {
      return _user!.toJson();
    }
    return null;
  }
}
