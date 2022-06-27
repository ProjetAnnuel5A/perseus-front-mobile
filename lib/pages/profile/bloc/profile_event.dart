part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileStarted extends ProfileEvent {}

class HeightChanged extends ProfileEvent {
  const HeightChanged(this.profile, this.height);

  final Profile profile;
  final int height;
}

class WeightChanged extends ProfileEvent {
  const WeightChanged(this.profile, this.weight);

  final Profile profile;
  final double weight;
}

class BirthDateChanged extends ProfileEvent {
  const BirthDateChanged(this.profile, this.birthDate);

  final Profile profile;
  final DateTime birthDate;
}

class LevelChanged extends ProfileEvent {
  const LevelChanged(this.profile, this.level);

  final Profile profile;
  final Level level;
}

class ObjectiveChanged extends ProfileEvent {
  const ObjectiveChanged(this.profile, this.objective);

  final Profile profile;
  final Objective objective;
}

class AvailabilityChanged extends ProfileEvent {
  const AvailabilityChanged(this.profile, this.availability);

  final Profile profile;
  final List<String> availability;
}

class ProfileUpdate extends ProfileEvent {
  const ProfileUpdate(this.profile);

  final Profile profile;
}
