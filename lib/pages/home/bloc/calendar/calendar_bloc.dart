import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<CalendarEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<UpdateFormat>((event, emit) {
      calendarFormat = event.calendarFormat;
      emit(CalendarInitial(format: calendarFormat));
    });
  }

  CalendarFormat calendarFormat = CalendarFormat.week;
  final DateTime focusedDay = DateTime.now();
}
