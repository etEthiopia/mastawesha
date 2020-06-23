import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastawesha/blocs/auth_form/form_bloc.dart';
import 'package:mastawesha/blocs/auth_form/form_state.dart';
import 'package:mastawesha/screens/auth/register_page.dart';
import 'package:mastawesha/screens/auth/login_page.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthFormBloc, AuthFormState>(
          bloc: BlocProvider.of<AuthFormBloc>(context),
          builder: (context, AuthFormState state) {
            if (state.currentForm == 0) {
              return SignIn();
            } else {
              return SignUp();
            }
          }),
    );
  }
}
