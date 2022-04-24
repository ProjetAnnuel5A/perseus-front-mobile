import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial(selectDay: DateTime.now())) {
    // remove time for equality
    final now = DateTime.now();

    // TODO Query workouts from db
    selectedWorkouts = {
      now: [const Workout('PPL'), const Workout('PPL')],
    };

    on<CalendarEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<UpdateFormat>((event, emit) {
      calendarFormat = event.calendarFormat;
      emit(CalendarInitial(format: calendarFormat, selectDay: selectedDay));
    });

    on<SelectDay>((event, emit) {
      selectedDay = event.selectedDay;
      emit(CalendarInitial(format: calendarFormat, selectDay: selectedDay));
    });
  }

  CalendarFormat calendarFormat = CalendarFormat.week;
  final DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  Map<DateTime, List<Workout>> selectedWorkouts = {};
}
