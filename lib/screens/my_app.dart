import 'package:flutter/material.dart';
import 'package:mastawesha/screens/auth/login_page.dart';
import 'dart:convert';
import 'package:mastawesha/screens/home.dart';
import 'package:mastawesha/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
        return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthService())],
      child: MaterialApp(
        title: 'Authentication Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: jwtOrEmpty,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data != "") {
                var str = snapshot.data;
                var jwt = str.split(".");
                if (jwt.length != 3) {
                  return LoginPage();
                } else {
                  var payload = json.decode(
                      ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                  if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                      .isAfter(DateTime.now())) {
                        final AuthService authService = Provider.of<AuthService>(context);
                    authService.payload = json.decode(ascii.decode(
                        base64.decode(base64.normalize(str.split(".")[1]))));
                    authService.jwt = str;
                    return HomePage();
                  } else {
                    return LoginPage();
                  }
                }
              } else {
                return LoginPage();
              }
            }),
      ),
    );
  }
}
