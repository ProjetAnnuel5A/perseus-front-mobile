part of 'exercise_bloc.dart';

abstract class ExerciseState {
  const ExerciseState();
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  const ExerciseLoaded(this.exercise);
  final Exercise exercise;
}
