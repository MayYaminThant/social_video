import 'package:flutter/material.dart';

class PasswordVisibilityController with ChangeNotifier {
  bool _isShowPassword = false;
  bool get isShowPassword => _isShowPassword;

  set isShowPassword(bool isShowPassword) {
    if (isShowPassword == _isShowPassword) {
      return;
    }
    _isShowPassword = isShowPassword;
    notifyListeners();
  }
}
