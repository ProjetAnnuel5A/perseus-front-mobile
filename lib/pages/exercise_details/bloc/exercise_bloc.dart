import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/model/exercise.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc(Exercise exercise) : super(ExerciseInitial()) {
    on<ExerciseStarted>((event, emit) {
      emit(ExerciseLoaded(exercise));
    });

    on<ExerciseEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<IncrementRepetition>((event, emit) {
      final exercise = event.exercise;
      exercise.exercisesData[event.index].repetition++;

      emit(ExerciseLoaded(exercise));
    });

    on<DecrementRepetition>((event, emit) {
      final exercise = event.exercise;
      exercise.exercisesData[event.index].repetition--;

      emit(ExerciseLoaded(exercise));
    });

    add(ExerciseStarted());
  }
}
