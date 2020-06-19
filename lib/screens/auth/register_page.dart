import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/global/global.dart';
import 'package:mastawesha/main.dart';
import 'package:mastawesha/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                        var res = await attemptSignUp(
                            _emailController.text, _passwordController.text);
                        if (res == 201) {
                          print("sign up: sucess");
                          displayDialog(context, "Success",
                              "The user was created. Log in now.");
                        } else if (res == 409) {
                          print("sign up: already registered");
                          displayDialog(
                              context,
                              "That username is already registered",
                              "Please try to sign up using another username or log in if you already have an account.");
                        } else {
                          print("sign up: Error");
                          displayDialog(
                              context, "Error", "An unknown error occurred.");
                        }
                      }
                    },
                    color: darkRedColor,
                    child: Text(
                      "Sign Up",
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

  Future<int> attemptSignUp(String username, String password) async {
    var res = await http.post('$SERVER_IP/signup',
        body: {"username": username, "password": password});
    return res.statusCode;
  }
}
