import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/global/global.dart';
import 'package:mastawesha/main.dart';
import 'package:mastawesha/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: darkGreyColor,
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: darkRedColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white.withOpacity(0.8),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Email",
                            icon: Icon(Icons.mail),
                            border: InputBorder.none,
                            isDense: true),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The password cannot be empty";
                          } else {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white.withOpacity(0.8),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Password",
                            icon: Icon(Icons.lock),
                            border: InputBorder.none,
                            isDense: true),
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The password cannot be empty";
                          } else if (value.length < 6) {
                            return "The password length must be at least six";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var jwt = await attemptLogIn(
                            _emailController.text, _passwordController.text);
                        if (jwt != null) {
                          storage.write(key: "jwt", value: jwt);
                          authService.jwt = jwt;
                          authService.payload = json.decode(ascii.decode(base64
                              .decode(base64.normalize(jwt.split(".")[1]))));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             HomePage.fromBase64(jwt)));
                        } else {
                          displayDialog(context, "An Error Occurred",
                              "No account was found matching that username and password");
                        }
                      }
                    },
                    color: darkRedColor,
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    color: redColor,
                    child: Text(
                      "Create an Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
            )),
      ),
    );
  }

  // Helper Method
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<String> attemptLogIn(String email, String password) async {
    var res = await http.post("$SERVER_IP/users/login",
        body: {"email": email, "password": password});
    if (res.statusCode == 200) return res.body;
    return null;
  }
}
