import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/blocs/auth_form/form_bloc.dart';
import 'package:mastawesha/blocs/auth_form/form_event.dart';
import 'package:mastawesha/blocs/authentication/authentication_bloc.dart';
import 'package:mastawesha/blocs/authentication/authentication_event.dart';
import 'package:mastawesha/blocs/authentication/authetnication_state.dart';
import 'package:mastawesha/blocs/login/login_bloc.dart';
import 'package:mastawesha/blocs/login/login_event.dart';
import 'package:mastawesha/blocs/login/login_state.dart';
import 'package:mastawesha/global/global.dart';
import 'package:mastawesha/main.dart';
import 'package:mastawesha/services/auth_service.dart';
import 'package:mastawesha/servicescopy/authentication_service.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //_layout(authService: authService)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor,
      body:
          SafeArea(child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final authBloc = BlocProvider.of<AuthenticationBloc>(context);
          if (state is AuthenticationNotAuthenticated) {
            return _AuthForm(); // show authentication form
          }
          if (state is AuthenticationFailure) {
            // show error message
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(state.message),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Retry'),
                  onPressed: () {
                    authBloc.add(AppLoaded());
                  },
                )
              ],
            ));
          } else if (state is Registered) {
            return _AuthForm(); // s
          }
          // show splash screen
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      print("FORM KEY: " + _key.currentState.toString());
      if (_key.currentState.validate()) {
        _loginBloc.add(LoginInWithEmailButtonPressed(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

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
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
      );
    }

    Widget _signinBtn(LoginState state) {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: darkRedColor,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed:
                state is LoginLoading ? () {} : () => {_onLoginButtonPressed()},
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
            onPressed: () =>
                BlocProvider.of<AuthFormBloc>(context).add(ToSignUpEvent()),
            child: Text(
              "Create an Account",
              style: TextStyle(color: Colors.white, fontFamily: defaultFont),
            ),
          ),
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Orientation orientation = MediaQuery.of(context).orientation;

          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
              reverse: true,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 6,
                      horizontal: 20.0),
                  child: Form(
                    key: _key,
                    autovalidate: _autoValidate,
                    child: Column(children: <Widget>[
                      _logoSection(),
                      _sizedBox(),
                      _emailPrompt(),
                      _passwordPrompt(),
                      _sizedBox(),
                      _signinBtn(state),
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
                        key: _key,
                        autovalidate: _autoValidate,
                        child: Column(children: <Widget>[
                          _emailPrompt(),
                          _passwordPrompt(),
                          _sizedBox(),
                          _signinBtn(state),
                          _sizedBox(),
                        ]),
                      )),
                ],
              ),
            ));
          }

          // Form(
          //   key: _key,
          //   autovalidate: _autoValidate,
          //   child: SingleChildScrollView(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: <Widget>[
          //         TextFormField(
          //           decoration: InputDecoration(
          //             labelText: 'Email address',
          //             filled: true,
          //             isDense: true,
          //           ),
          //           controller: _emailController,
          //           keyboardType: TextInputType.emailAddress,
          //           autocorrect: false,
          //           validator: (value) {
          //             if (value == null) {
          //               return 'Email is required.';
          //             }
          //             return null;
          //           },
          //         ),
          //         SizedBox(
          //           height: 12,
          //         ),
          //         TextFormField(
          //           decoration: InputDecoration(
          //             labelText: 'Password',
          //             filled: true,
          //             isDense: true,
          //           ),
          //           obscureText: true,
          //           controller: _passwordController,
          //           validator: (value) {
          //             if (value == null) {
          //               return 'Password is required.';
          //             }
          //             return null;
          //           },
          //         ),
          //         const SizedBox(
          //           height: 16,
          //         ),
          //         RaisedButton(
          //           color: Theme.of(context).primaryColor,
          //           textColor: Colors.white,
          //           padding: const EdgeInsets.all(16),
          //           shape: new RoundedRectangleBorder(
          //               borderRadius: new BorderRadius.circular(8.0)),
          //           child: Text('LOG IN'),
          //           onPressed:
          //               state is LoginLoading ? () {} : _onLoginButtonPressed,
          //         )
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  void _showError(String error) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
