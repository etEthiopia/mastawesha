import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mastawesha/main.dart';
import 'package:http/http.dart' as http;

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

  void setupUser(String str) {
    jwt = str;
    payload = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1]))));
    storage.write(key: "jwt", value: jwt);
  }

  // Stream<User> get onAuthStateChanged {
  //   return User.instance as Stream<User>;
  // }

  Future<int> attemptLogIn({String email, String password}) async {
    var res = await http.post("$SERVER_IP/users/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{"email": email, "password": password}));
    if (res.statusCode == 200) {
      if (res.body != null) {
        String jwtP = res.body;
        print("JWT: " + jwtP);
        setupUser(jwtP);
        return res.statusCode;
      } else {
        return res.statusCode;
      }
    }

    return null;
  }

  Future<int> attemptSignUp(
      {String email, String password, String fname, String lname}) async {
    var res = await http.post('$SERVER_IP/users/register',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "firstname": fname,
          "lastname": lname,
          "email": email,
          "password": password
        }));
    return res.statusCode;
  }

  Future<int> attemptSignUpwithPic({FormData formData}) async {
    var res = await Dio().post(
      '$SERVER_IP/users/registerp',
      // options: Options(headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // }
      // ),
      data: formData,
      onSendProgress: (int sent, int total) {
        print("$sent ---- $total");
      },
    );
    return res.statusCode;
  }

  void logout() async {
    await storage.delete(key: "jwt");
    jwt = null;
    payload = null;
  }
}
