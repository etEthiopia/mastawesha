import 'dart:convert';

import 'package:flutter/cupertino.dart';

class User {
  static User instance = User();

  setUser(String jwt) {
    instance.jwt = jwt;
    instance.payload = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1]))));
    instance.email = this.payload['email'];
    instance.fname = this.payload['firstname'];
    instance.lname = this.payload['lastname'];
  }

  String email;
  String fname;
  String lname;
  String jwt;
  dynamic payload;
    
}
