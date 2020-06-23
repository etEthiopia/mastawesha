import 'package:bloc/bloc.dart';
import 'package:mastawesha/blocs/auth_form/form_event.dart';
import 'package:mastawesha/blocs/auth_form/form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  @override
  AuthFormState get initialState => AuthFormState.initial();

  @override
  Stream<AuthFormState> mapEventToState(AuthFormEvent event) async* {
    if (event is ToSignUpEvent) {
      yield AuthFormState(currentForm: 1);
      print("SU " + state.currentForm.toString());
    } else if (event is ToSignInEvent) {
      yield AuthFormState(currentForm: 0);
      print("SI " + state.currentForm.toString());
    }
  }
}
