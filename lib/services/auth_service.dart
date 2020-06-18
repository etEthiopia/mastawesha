import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  var _payload;
  String _jwt;

  String get jwt => _jwt;

  set jwt(String j) {
    _jwt = j;
    notifyListeners();
  }

  get payload => _payload;

  set payload(var p) {
    _payload = p;
    notifyListeners();
  }
}
