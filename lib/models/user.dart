import 'dart:convert';

import 'package:meta/meta.dart';

class User {
  String fname;
  String lname;
  String email;
  final jwt;
  var payload;

  User({@required this.jwt}) {
    final parts = jwt.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final ppayload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(ppayload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    payload = payloadMap;
    fname = payload['firstname'];
    lname = payload['lastname'];
    email = payload['email'];
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(jwt: json['token']);
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  @override
  String toString() => 'User { fname: $fname, lname: $lname, email: $email}';
}
