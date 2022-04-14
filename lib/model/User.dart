import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.username, this.email, this.password);

  final String username;
  final String email;
  final String password;

  @override
  List<Object?> get props => [
        username,
        email,
        password,
      ];
}
