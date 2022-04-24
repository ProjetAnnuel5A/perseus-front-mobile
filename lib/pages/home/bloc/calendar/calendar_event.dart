part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class UpdateFormat extends CalendarEvent {
  const UpdateFormat({required this.calendarFormat});
  final CalendarFormat calendarFormat;

  @override
  List<Object> get props => [calendarFormat];
}

class SelectDay extends CalendarEvent {
  const SelectDay({required this.selectedDay});
  final DateTime selectedDay;

  @override
  List<Object> get props => [selectedDay];
}