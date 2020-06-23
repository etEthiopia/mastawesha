import 'package:equatable/equatable.dart';

abstract class AuthFormEvent {}

class ToSignUpEvent extends AuthFormEvent {}

class ToSignInEvent extends AuthFormEvent {}
