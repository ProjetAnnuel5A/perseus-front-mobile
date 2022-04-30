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
      focusedDay = event.selectedDay;
      
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

    // Initialize calendar values
    final _now = DateTime.now();

    focusedDay = _now;
    selectedDay = _now;
    firstDay = _now.subtract(const Duration(days: 365));
    lastDay = _now.add(const Duration(days: 365));

    try {
      workouts = await _workoutRepository.getAll();
      emit(CalendarLoaded(workouts: workouts, selectDay: DateTime.now()));
    } catch (_) {
      // error case emit(CalendarError());
    }
  }

  final WorkoutRepository _workoutRepository;

  CalendarFormat calendarFormat = CalendarFormat.week;

  /// DateTime that determines which days are currently visible and focused.
  DateTime focusedDay = DateTime.fromMillisecondsSinceEpoch(0);

  /// Signature for `onDaySelected` callback.
  /// Contains the selected day and focused day.
  DateTime selectedDay = DateTime.fromMillisecondsSinceEpoch(0);

  /// The first active day of `TableCalendar`.
  DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(0);

  /// The last active day of `TableCalendar`.
  DateTime lastDay = DateTime.fromMillisecondsSinceEpoch(0);

  List<Workout> workouts = [];
}
