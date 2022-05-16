part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class ExerciseStarted extends ExerciseEvent {}

class IncrementRepetition extends ExerciseEvent {
  const IncrementRepetition(this.exercise, this.index);

  final Exercise exercise;
  final int index;

  @override
  List<Object> get props => [exercise];
}

class DecrementRepetition extends ExerciseEvent {
  const DecrementRepetition(this.exercise, this.index);

  final Exercise exercise;
  final int index;

  @override
  List<Object> get props => [exercise];
}

class ValidateExercisesData extends ExerciseEvent {
  const ValidateExercisesData(this.exercisesData, this.exerciseIds);

  final List<ExerciseData> exercisesData;
  final List<String> exerciseIds;
}
