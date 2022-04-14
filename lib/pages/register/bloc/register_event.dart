part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterValidateFormEvent extends RegisterEvent {
  const RegisterValidateFormEvent(this.username, this.email, this.password);

  final String username;
  final String email;
  final String password;
}
