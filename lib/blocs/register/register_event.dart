import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterPressed extends RegisterEvent {
  final String fname;
  final String lname;
  final String email;
  final String password;

  RegisterPressed({
    @required this.email,
    @required this.password,
    @required this.fname,
    @required this.lname,
  });

  @override
  List<Object> get props => [fname, lname, email, password];
}

class RegisterPressedWithPic extends RegisterEvent {
  final FormData formData;

  RegisterPressedWithPic({@required this.formData});

  @override
  List<Object> get props => [formData];
}
