import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/blocs/authentication/authentication_bloc.dart';
import 'package:mastawesha/blocs/authentication/authentication_event.dart';
import 'package:mastawesha/blocs/authentication/authetnication_state.dart';
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
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
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
                authBloc.add(UserLoggedOut());
              }),
        ],
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return Center(child: Text(state.user.fname, style: bigTitleStyle));
          } else {
            print("Not here");
            return null;
          }
        },
      ),
    );
  }
}
