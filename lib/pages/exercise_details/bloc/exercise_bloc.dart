import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/exercise_data.dart';
import 'package:perseus_front_mobile/repositories/exercise_data_repository.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc(this._exerciseDataRepository, Exercise exercise)
      : super(ExerciseInitial()) {
    on<ExerciseStarted>((event, emit) {
      emit(ExerciseLoaded(exercise));
    });

    on<ValidateExercisesData>((event, emit) {
      _exerciseDataRepository.updateExercisesData(event.exercisesData);
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

  final ExerciseDataRepository _exerciseDataRepository;
}
