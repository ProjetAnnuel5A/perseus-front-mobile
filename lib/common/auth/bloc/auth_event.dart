part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class Logout extends AuthEvent {}

class DeleteAccount extends AuthEvent {}
class LoggedIn extends AuthEvent {
  LoggedIn(this.username, this.token);

  final String username;
  final String token;
}
