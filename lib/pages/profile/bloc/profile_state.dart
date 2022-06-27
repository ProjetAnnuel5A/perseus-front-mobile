part of 'profile_bloc.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final Profile profile;
}

class ProfileError extends ProfileState {
  const ProfileError(this.httpException);
  final HttpException httpException;
}
