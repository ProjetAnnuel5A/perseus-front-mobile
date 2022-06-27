part of 'set_bloc.dart';

abstract class SetEvent extends Equatable {
  const SetEvent();

  @override
  List<Object> get props => [];
}

class SetStarted extends SetEvent {}

class IncrementRepetition extends SetEvent {
  const IncrementRepetition(this.set, this.index);

  final Set set;
  final int index;

  @override
  List<Object> get props => [set];
}

class DecrementRepetition extends SetEvent {
  const DecrementRepetition(this.set, this.index);

  final Set set;
  final int index;

  @override
  List<Object> get props => [set];
}

class IncrementWeight extends SetEvent {
  const IncrementWeight(this.set, this.index);

  final Set set;
  final int index;

  @override
  List<Object> get props => [set];
}

class DecrementWeight extends SetEvent {
  const DecrementWeight(this.set, this.index);

  final Set set;
  final int index;

  @override
  List<Object> get props => [set];
}

class ValidateSet extends SetEvent {
  const ValidateSet(this.setId, this.exercises);

  final String setId;
  final List<Exercise> exercises;
}
