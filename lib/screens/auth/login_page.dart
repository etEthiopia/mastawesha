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

  Widget _logoSection() {
    return Container(
        margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
        alignment: Alignment.topCenter,
        child: Image.asset(
          "assets/images/icons/logo1-S.png",
          width: 100.0,
        ));
  }

  Widget _sizedBox() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget _emailPrompt() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white.withOpacity(0.8),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
    );
  }

  Widget _passwordPrompt() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white.withOpacity(0.8),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
    );
  }

  Widget _signinBtn({AuthService authService}) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: darkRedColor,
        borderRadius: BorderRadius.circular(15.0),
        child: FlatButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              var jwt = await attemptLogIn(
                  email: _emailController.text,
                  password: _passwordController.text);
              if (jwt != null) {
                storage.write(key: "jwt", value: jwt);
                authService.jwt = jwt;
                authService.payload = json.decode(ascii.decode(
                    base64.decode(base64.normalize(jwt.split(".")[1]))));
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
          child: Text(
            "Sign In",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: defaultFont),
          ),
        ),
      ),
    );
  }

  Widget _orText() {
    return Center(
      child: Text(
        "or",
        style: TextStyle(color: Colors.white, fontFamily: defaultFont),
      ),
    );
  }

  Widget _divider() {
    return Divider(color: redColor);
  }

  Widget _createaccountBtn() {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: redColor,
        borderRadius: BorderRadius.circular(15.0),
        child: FlatButton(
          onPressed: () {
            widget.toggleView();
          },
          child: Text(
            "Create an Account",
            style: TextStyle(color: Colors.white, fontFamily: defaultFont),
          ),
        ),
      ),
    );
  }

  Widget _layout({AuthService authService}) {
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 6,
                horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                _logoSection(),
                _sizedBox(),
                _emailPrompt(),
                _passwordPrompt(),
                _sizedBox(),
                _signinBtn(authService: authService),
                _sizedBox(),
                _orText(),
                _divider(),
                _createaccountBtn()
              ]),
            )),
      );
    } else {
      return Container(
          child: SingleChildScrollView(
        reverse: true,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 4,
                  horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  _logoSection(),
                  _divider(),
                  _createaccountBtn()
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 1.5,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 4,
                    horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    _emailPrompt(),
                    _passwordPrompt(),
                    _sizedBox(),
                    _signinBtn(authService: authService),
                    _sizedBox(),
                  ]),
                )),
          ],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: darkGreyColor,
      body: _layout(authService: authService),
    );
  }

  // Helper Method
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(title, style: TextStyle(fontFamily: defaultFont)),
            content: Text(
              text,
              style: TextStyle(fontFamily: defaultFont),
            )),
      );

  Future<String> attemptLogIn({String email, String password}) async {
    var res = await http.post("$SERVER_IP/users/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{"email": email, "password": password}));
    if (res.statusCode == 200) return res.body;
    return null;
  }
}
