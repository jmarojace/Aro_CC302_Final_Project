import 'package:flutter/foundation.dart';

class AuthStore extends ChangeNotifier {
  static const _email = 'arojoshua185@gmail.com';
  static const _password = 'admin123';

  bool isLoggedIn = false;

  String get accountEmail => _email;

  bool login(String email, String password) {
    final ok = email.trim().toLowerCase() == _email && password == _password;
    if (ok) {
      isLoggedIn = true;
      notifyListeners();
    }
    return ok;
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}

final auth = AuthStore();
