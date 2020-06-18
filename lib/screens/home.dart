import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/main.dart';

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secret Data Screen"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                storage
                    .read(key: "jwt")
                    .then((value) => print(value))
                    .catchError((e) => print("error: " + e));
                storage.delete(key: "jwt");
                print("deleted");
                storage
                    .read(key: "jwt")
                    .then((value) => print(value))
                    .catchError((e) => print("error: " + e));
              }),
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future:
                http.read('$SERVER_IP/data', headers: {"Authorization": jwt}),
            builder: (context, snapshot) => snapshot.hasData
                ? Column(
                    children: <Widget>[
                      Text("${payload['username']}, here's the data:"),
                      Text(snapshot.data,
                          style: Theme.of(context).textTheme.display1)
                    ],
                  )
                : snapshot.hasError
                    ? Text("An error occurred")
                    : CircularProgressIndicator()),
      ),
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
