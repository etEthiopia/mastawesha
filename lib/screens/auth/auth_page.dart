import 'package:flutter/material.dart';
import 'package:mastawesha/screens/auth/login_page.dart';
import 'package:mastawesha/screens/auth/register_page.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Container(child: SignIn(toggleView: this.toggleView));
    } else {
      return Container(child: SignUp(toggleView: this.toggleView));
    }
  }
}
