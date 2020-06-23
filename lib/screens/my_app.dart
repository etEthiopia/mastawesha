import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastawesha/blocs/authentication/authentication_bloc.dart';
import 'package:mastawesha/blocs/authentication/authetnication_state.dart';
import 'package:mastawesha/screens/auth/auth_page.dart';
import 'package:mastawesha/screens/home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // BlocBuilder will listen to changes in AuthenticationState
      // and build an appropriate widget based on the state.
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page
            return HomePage();
          }
          // otherwise show login page
          return Authenticate();
        },
      ),
    );
  }
}
