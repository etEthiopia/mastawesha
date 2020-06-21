import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mastawesha/global/global.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import 'home.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();

  Widget loading() {
    return Scaffold(
        backgroundColor: darkGreyColor,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/images/icons/logo1-S.png",
                    width: 100.0,
                  )),
              SpinKitCubeGrid(size: 100, color: redColor)
            ])));
  }
}

class _LandingPageState extends State<LandingPage> {
  String loading = "";

  get ascii => null;
  void jwtOrEmpty() async {
    var jwt = await storage.read(key: "jwt");
    if (jwt != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    str: jwt,
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
    jwtOrEmpty();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      loading = jwtOrEmpty as String;
    });

    return Container(
      color: darkGreyColor,
      child: Column(children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/images/icons/logo1-S.png",
              width: 100.0,
            )),
        SpinKitCubeGrid(size: 100)
      ]),
    );
  }
}
