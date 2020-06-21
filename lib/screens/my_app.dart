import 'package:flutter/material.dart';
import 'package:mastawesha/global/global.dart';
import 'dart:convert';
import 'package:mastawesha/screens/home.dart';
import 'package:mastawesha/screens/landing.dart';
import 'package:mastawesha/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'auth/auth_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  Widget home = LandingPage();
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthService())],
      // providers: [
      //   ChangeNotifierProvider<AuthService>.value(value: AuthService())
      // ],
      child: MaterialApp(
        title: 'Mastawesha',
        home: FutureBuilder(
            future: widget.jwtOrEmpty,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data != "") {
                var str = snapshot.data;
                var jwt = str.split(".");
                if (jwt.length != 3) {
                  return Authenticate();
                } else {
                  var payload = json.decode(
                      ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                  if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                      .isAfter(DateTime.now())) {
                    final AuthService authService =
                        Provider.of<AuthService>(context);
                    authService.setupUser(str);
                    // authService.payload = json.decode(ascii.decode(
                    //     base64.decode(base64.normalize(str.split(".")[1]))));
                    return HomePage();
                  } else {
                    return Authenticate();
                  }
                }
              } else {
                return Authenticate();
              }
            }),
      ),
    );
  }
}
