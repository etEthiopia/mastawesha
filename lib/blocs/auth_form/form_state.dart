import 'package:equatable/equatable.dart';

class AuthFormState {
  final int currentForm;

  const AuthFormState({this.currentForm});

  factory AuthFormState.initial() => AuthFormState(currentForm: 0);
}
