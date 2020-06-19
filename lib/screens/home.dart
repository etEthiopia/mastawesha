import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/main.dart';
import 'package:mastawesha/screens/auth/login_page.dart';
import 'package:mastawesha/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  // final String jwt;
  // final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Secret Data Screen"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                storage.delete(key: "jwt");
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
                authService.jwt = null;
                authService.payload = null;
                print("deleted");
              }),
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: http.read('$SERVER_IP/data', headers: {
              "Authorization": authService.jwt
            }).catchError((e) => {print(e.toString())}),
            builder: (context, snapshot) => snapshot.hasData
                ? Column(
                    children: <Widget>[
                      Text(
                          "${authService.payload['username']}, here's the data:"),
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
