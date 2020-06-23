import 'package:bloc/bloc.dart';
import 'package:mastawesha/blocs/authentication/authentication_bloc.dart';
import 'package:mastawesha/blocs/authentication/authentication_event.dart';
import 'package:mastawesha/blocs/register/register_event.dart';
import 'package:mastawesha/blocs/register/register_state.dart';
import 'package:mastawesha/servicescopy/services.dart';
//import 'package:bloc_pattern_full/blocs/authentication/authentication_bloc.dart';
//import 'package:bloc_pattern_full/blocs/authentication/authentication_event.dart';

import '../../exceptions/exceptions.dart';
//import '../../services/services.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  RegisterBloc(AuthenticationBloc authenticationBloc,
      AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService;

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterPressed) {
      yield* _mapRegisterPressedToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterPressedToState(
      RegisterPressed event) async* {
    yield RegisterLoading();
    try {
      print("ABOUT to fire method");
      final code = await _authenticationService.signUp(
          event.fname, event.lname, event.email, event.password);
      if (code == 201) {
        // push new authentication event
        _authenticationBloc.add(UserRegistered());
        yield RegisterSuccess();
        yield RegisterInitial();
      } else {
        yield RegisterFailure(error: 'Something very weird just happened');
      }
    } on AuthenticationException catch (e) {
      yield RegisterFailure(error: e.message);
    } catch (err) {
      yield RegisterFailure(error: err.message ?? 'An unknown error occured');
    }
  }
}
