import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationLoginRequested) {
      yield* _mapLoginRequestedToState(event);
    } else if (event is AuthenticationLoggedOut) {
      yield AuthenticationUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoginRequestedToState(AuthenticationLoginRequested event) async* {
    final email = event.email;
    final password = event.password;

    try {
      if (!isValidEmail(email)) {
        throw Exception('Invalid email format');
      }
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters long');
      }
      yield AuthenticationAuthenticated(email: email);
    } catch (e) {
      yield AuthenticationError(error: e.toString());
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}
