import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:perseus_front_mobile/repositories/workout_repository.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this._workoutRepository) : super(CalendarInitial()) {
    on<CalendarStarted>(_onStarted);

    // use copyWith

    on<UpdateFormat>((event, emit) {
      calendarFormat = event.calendarFormat;
      emit(
        CalendarLoaded(
          workouts: workouts,
          format: calendarFormat,
          selectDay: selectedDay,
        ),
      );
    });

    on<SelectDay>((event, emit) {
      selectedDay = event.selectedDay;
      emit(
        CalendarLoaded(
          workouts: workouts,
          format: calendarFormat,
          selectDay: selectedDay,
        ),
      );
    });

    add(CalendarStarted());
  }

  Future<void> _onStarted(
    CalendarStarted event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      workouts = await _workoutRepository.getAll();
      emit(CalendarLoaded(workouts: workouts, selectDay: DateTime.now()));
    } catch (_) {
      // error case emit(CalendarError());
    }
  }

  final WorkoutRepository _workoutRepository;

  CalendarFormat calendarFormat = CalendarFormat.week;
  final DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  List<Workout> workouts = [];
}
