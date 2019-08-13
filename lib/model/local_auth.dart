import 'package:flutter/material.dart';

class LocalAuthenticate with ChangeNotifier {
  bool _authenticated = false;

  bool get authenticated => _authenticated;

  set authenticated(bool value) {
    _authenticated = value;
    notifyListeners();
  }

  LocalAuthenticate(this._authenticated);
}
