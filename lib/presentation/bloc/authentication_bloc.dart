import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationLoginRequested>(_onLoginRequested);
    on<AuthenticationLoggedOut>(_onLoggedOut);
  }

  Future<void> _onLoginRequested(
      AuthenticationLoginRequested event, Emitter<AuthenticationState> emit) async {
    final email = event.email;
    final password = event.password;

    try {
      if (!isValidEmail(email)) {
        throw Exception('Invalid email format');
      }
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters long');
      }
      emit(AuthenticationAuthenticated(email: email));
    } catch (e) {
      emit(AuthenticationError(error: e.toString()));
    }
  }

  void _onLoggedOut(
      AuthenticationLoggedOut event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationUnauthenticated());
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}
