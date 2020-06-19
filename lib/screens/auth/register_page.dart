import 'dart:convert';

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
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: TextStyle(fontFamily: defaultFont),
        ),
        backgroundColor: darkRedColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                            hintText: "First Name",
                            icon: Icon(Icons.person),
                            border: InputBorder.none,
                            isDense: true),
                        keyboardType: TextInputType.text,
                        controller: _fnameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "First Name cannot be empty";
                          } else if (value.length > 15) {
                            return "First Name length must be < 15";
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
                            hintText: "Last Name",
                            icon: Icon(Icons.person),
                            border: InputBorder.none,
                            isDense: true),
                        keyboardType: TextInputType.text,
                        controller: _lnameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Last Name cannot be empty";
                          } else if (value.length > 15) {
                            return "Last Name length must be < 15";
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
                            hintText: "Email",
                            icon: Icon(Icons.mail),
                            border: InputBorder.none,
                            isDense: true),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The Email cannot be empty";
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
                        obscureText: true,
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
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Confirm Password",
                            icon: Icon(Icons.lock),
                            border: InputBorder.none,
                            isDense: true),
                        controller: _cpasswordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "please confirm password";
                          } else if (value != _passwordController.text) {
                            return "passwords doesn't match";
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
                            fname: _fnameController.text,
                            lname: _lnameController.text,
                            email: _emailController.text,
                            password: _passwordController.text);
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
                      style: TextStyle(
                          color: Colors.white, fontFamily: defaultFont),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Text(
                    "or",
                    style:
                        TextStyle(color: Colors.white, fontFamily: defaultFont),
                  ),
                ),
                Divider(color: redColor),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    color: redColor,
                    child: Text(
                      "Already have an Account?",
                      style: TextStyle(
                          color: Colors.white, fontFamily: defaultFont),
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
        builder: (context) => AlertDialog(
            title: Text(title, style: TextStyle(fontFamily: defaultFont)),
            content: Text(text, style: TextStyle(fontFamily: defaultFont))),
      );

  Future<int> attemptSignUp(
      {String email, String password, String fname, String lname}) async {
    var res = await http.post('$SERVER_IP/users/register',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "firstname": fname,
          "lastname": lname,
          "email": email,
          "password": password
        }));
    return res.statusCode;
  }
}