import 'dart:convert';

import '../exceptions/exceptions.dart';
import '../main.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationService {
  Future<User> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class FakeAuthenticationService extends AuthenticationService {
  @override
  Future<User> getCurrentUser() async {
    var str = await storage.read(key: "jwt");

    if (str != null) {
      var jwt = str.split(".");

      if (jwt.length == 3) {
        return User(jwt: str);
      }
    }
    return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    var res = await http.post("$SERVER_IP/users/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{"email": email, "password": password}));
    if (res.statusCode == 200) {
      if (res.body != null) {
        await storage.write(key: "jwt", value: json.decode(res.body)['token']);
        return User.fromJson(json.decode(res.body));
      } else {
        return null;
      }
    } else {
      throw AuthenticationException(message: 'Wrong username or password');
    }
  }

  @override
  Future<void> signOut() async {
    await storage.delete(key: "jwt");
    return null;
  }
}
