import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mastawesha/screens/my_app.dart';

const SERVER_IP = 'http://192.168.1.3:3000';
final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}
