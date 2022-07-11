part of 'profile_bloc.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile, {this.isOffline = false});

  final Profile profile;
  final bool isOffline;
}

class ProfileError extends ProfileState {
  const ProfileError(this.httpException);
  final HttpException httpException;
}
