import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/global/global.dart';
import 'package:mastawesha/main.dart';
import 'package:mastawesha/screens/auth/auth_page.dart';
import 'package:mastawesha/screens/auth/login_page.dart';
import 'package:mastawesha/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String str;
  HomePage({this.str});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    // authService.payload = json.decode(
    //     ascii.decode(base64.decode(base64.normalize(str.split(".")[1]))));
    // authService.jwt = str;
    print("build home page ");

    return Scaffold(
        backgroundColor: darkGreyColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Home", style: TextStyle(fontFamily: defaultFont)),
          backgroundColor: darkRedColor,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  authService.logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Authenticate()));
                  // authService.jwt = null;
                  // authService.payload = null;
                }),
          ],
        ),
        body: Center(
            child: Text(
          authService.payload['firstname'],
          style: bigTitleStyle,
        ))
        //       FutureBuilder(
        //           future: http
        //               .read('$SERVER_IP/users/')
        //               .catchError((e) => {print(e.toString())}),
        //           builder: (context, snapshot) => snapshot.hasData
        //               ? Column(
        //                   children: <Widget>[
        //                     Text(
        //                         "${authService.payload['firstname']}, here's the data:"),
        //                     Text(snapshot.data,
        //                         style: Theme.of(context).textTheme.display1)
        //                   ],
        //                 )
        //               : snapshot.hasError
        //                   ? Text("An error occurred")
        //                   : CircularProgressIndicator()),
        // );
        );
  }
}

// class HomePage extends StatelessWidget {
//   HomePage(this.jwt, this.payload);

//   factory HomePage.fromBase64(String jwt) => HomePage(
//       jwt,
//       json.decode(
//           ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

//   final String jwt;
//   final Map<String, dynamic> payload;
// }
