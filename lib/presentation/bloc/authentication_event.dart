
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
class AuthenticationLoggedOut extends AuthenticationEvent {}
