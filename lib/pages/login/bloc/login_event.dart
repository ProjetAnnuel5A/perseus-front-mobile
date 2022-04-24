part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUsernameChangedEvent extends LoginEvent {
  const LoginUsernameChangedEvent(this.username);

  final String username;
}

class LoginValidateFormEvent extends LoginEvent {
  const LoginValidateFormEvent(this.username, this.password);

  final String username;
  final String password;
}
