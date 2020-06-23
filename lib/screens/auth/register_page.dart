import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mastawesha/blocs/auth_form/form_bloc.dart';
import 'package:mastawesha/blocs/auth_form/form_event.dart';
import 'package:mastawesha/blocs/authentication/authentication_bloc.dart';

import 'package:mastawesha/blocs/register/register_bloc.dart';
import 'package:mastawesha/blocs/register/register_event.dart';
import 'package:mastawesha/blocs/register/register_state.dart';
import 'package:mastawesha/global/global.dart';

import 'package:mastawesha/services/authentication_service.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as p;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //_layout(authService: authService)
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: darkGreyColor, body: _AuthForm()
        // SafeArea(child: BlocBuilder<AuthFormBloc, AuthFormState>(
        //   builder: (context, state) {
        //     final formBloc = BlocProvider.of<AuthFormBloc>(context);
        //     if (state.currentForm == 1) {
        //       return _AuthForm(); // show authentication form
        //     } else if (state.currentForm == 0) {
        //       // show error message
        //       return
        //     }
        //     // show splash screen

        //     return Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        // )),
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
      child: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authBloc, authService),
        child: _SignUpForm(),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  __SignUpFormState createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  FormData formData;
  File _image;
  final picker = ImagePicker();
  bool loading = false;

  Future getImage() async {
    final PickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(PickedFile.path);
    });
  }

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _registerBloc = BlocProvider.of<RegisterBloc>(context);

    _onRegisterButtonPressed() {
      print("FORM KEY: " + _key.currentState.toString());
      if (_key.currentState.validate()) {
        _registerBloc.add(RegisterPressed(
          email: _emailController.text,
          password: _passwordController.text,
          fname: _fnameController.text,
          lname: _lnameController.text,
        ));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    _onRegisterWitPicButtonPressed() {
      print("FORM KEY: " + _key.currentState.toString());
      if (_key.currentState.validate()) {
        _registerBloc.add(RegisterPressedWithPic(formData: formData));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    Widget _sizedBox() {
      return SizedBox(
        height: 20.0,
      );
    }

    Widget _fnamePrompt() {
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
              textCapitalization: TextCapitalization.words,
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
      );
    }

    Widget _lnamePrompt() {
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
              textCapitalization: TextCapitalization.words,
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

    Widget _cpasswordPrompt() {
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
      );
    }

    Widget _signupBtn(RegisterState state) {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: darkRedColor,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () async {
              if (state is! RegisterLoading) {
                if (_image != null) {
                  formData = FormData.fromMap({
                    "firstname": _fnameController.text,
                    "lastname": _lnameController.text,
                    "email": _emailController.text,
                    "password": _passwordController.text,
                    "picture": await MultipartFile.fromFile(_image.path,
                        filename: p.basename(_image.path))
                  });

                  _onRegisterWitPicButtonPressed();
                } else {
                  _onRegisterButtonPressed();
                }
              }
            },
            child: Text(
              "Sign Up",
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

    Widget _titleSection() {
      return Text("Mastawesha", style: bigTitleStyle);
    }

    Widget _haveanaccountBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: redColor,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () =>
                BlocProvider.of<AuthFormBloc>(context).add(ToSignInEvent()),
            child: Text(
              "Already have an Account?",
              style: TextStyle(color: Colors.white, fontFamily: defaultFont),
            ),
          ),
        ),
      );
    }

    Widget _imagePrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Material(
            color: redColor,
            borderRadius: BorderRadius.circular(15.0),
            child: FlatButton(
              onPressed: () {
                getImage();
              },
              child: _image == null
                  ? Text(
                      "Add Picture",
                      style: TextStyle(
                          color: Colors.white, fontFamily: defaultFont),
                    )
                  : Text(
                      p.basename(_image.path),
                      style: TextStyle(
                          color: Colors.white, fontFamily: defaultFont),
                    ),
            ),
          ),
        ),
      );
    }

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          _showError(state.error);
        } else if (state is RegisterSuccess) {
          _displayDialog(
              context,
              "Successfully Registered",
              _fnameController.text +
                  ", your registration was successful. You can now login with your credentials");
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state is RegisterLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Orientation orientation = MediaQuery.of(context).orientation;
          if (loading) {
            return Container(
                child:
                    Center(child: SpinKitCubeGrid(color: redColor, size: 100)));
          } else if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
              reverse: true,
              child: Container(
                  padding: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: _key,
                    autovalidate: _autoValidate,
                    child: Column(children: <Widget>[
                      _sizedBox(),
                      _titleSection(),
                      _sizedBox(),
                      _fnamePrompt(),
                      _lnamePrompt(),
                      _emailPrompt(),
                      _passwordPrompt(),
                      _cpasswordPrompt(),
                      _sizedBox(),
                      _imagePrompt(),
                      _sizedBox(),
                      _signupBtn(state),
                      _sizedBox(),
                      _orText(),
                      _divider(),
                      _haveanaccountBtn(),
                    ]),
                  )),
            );
          } else {
            return SingleChildScrollView(
              reverse: true,
              child: Container(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20, bottom: 5.0),
                  child: Form(
                    key: _key,
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        _sizedBox(),
                        _titleSection(),
                        Row(children: <Widget>[
                          Expanded(
                            child: _fnamePrompt(),
                          ),
                          Expanded(
                            child: _lnamePrompt(),
                          ),
                        ]),
                        Row(children: <Widget>[
                          Expanded(
                            child: _emailPrompt(),
                          ),
                          Expanded(
                            child: _imagePrompt(),
                          ),
                        ]),
                        Row(children: <Widget>[
                          Expanded(
                            child: _passwordPrompt(),
                          ),
                          Expanded(
                            child: _cpasswordPrompt(),
                          ),
                        ]),
                        Row(children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _haveanaccountBtn(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _signupBtn(state),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  )),
            );
          }
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

  // Helper Method
  void _displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: darkGreyColor,
          title: Text(title,
              style: TextStyle(fontFamily: defaultFont, color: redColor)),
          content: Text(text,
              style: TextStyle(fontFamily: defaultFont, color: darkRedColor)),
          actions: <Widget>[
            FlatButton(
              color: darkRedColor,
              onPressed: () {
                BlocProvider.of<AuthFormBloc>(context).add(ToSignInEvent());
                Navigator.pop(context);
              },
              child: Text(
                "Log In",
                style: TextStyle(fontFamily: defaultFont, color: Colors.white),
              ),
            )
          ],
          actionsPadding: EdgeInsets.all(15.0),
        ),
      );
}
