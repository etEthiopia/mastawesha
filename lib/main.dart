import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mastawesha/blocs/auth_form/form_bloc.dart';
import 'package:mastawesha/screens/my_app.dart';
import 'package:mastawesha/services/authentication_service.dart';
import 'package:provider/provider.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';

const SERVER_IP = 'http://192.168.1.3:3000';
final storage = FlutterSecureStorage();

void main() => runApp(
    // Injects the Authentication service
    RepositoryProvider<AuthenticationService>(
        create: (context) {
          return FakeAuthenticationService();
        },
        // Injects the Authentication BLoC
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (context) {
                final authService =
                    RepositoryProvider.of<AuthenticationService>(context);
                return AuthenticationBloc(authService)..add(AppLoaded());
              },
            ),
            BlocProvider<AuthFormBloc>(
              create: (BuildContext context) => AuthFormBloc(),
            )
          ],
          child: MyApp(),
        )));
