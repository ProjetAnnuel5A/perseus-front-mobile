part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthUninitialized extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnauthenticated extends AuthState {}
