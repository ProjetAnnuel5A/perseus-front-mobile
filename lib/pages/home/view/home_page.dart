import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/counter/counter.dart';
import 'package:perseus_front_mobile/pages/home/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:perseus_front_mobile/pages/home/bloc/calendar/calendar_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
          create: (BuildContext context) => BottomNavigationBloc(),
        ),
        BlocProvider<CalendarBloc>(
          create: (BuildContext context) => CalendarBloc(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          if (state is PageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BottomNavigationInitial) {
            return _getHomePageContent(context);
          } else if (state is PageLoaded) {
            if (state.currentIndex == 1) {
              return _getHomePageContent(context);
            } else {
              return const CounterPage();
            }
          }
          return Container();
        },
      ),
      bottomNavigationBar:
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          return BottomNavigationBar(
            currentIndex: context.read<BottomNavigationBloc>().currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.verified_user),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.query_stats),
                label: 'Counter',
              ),
            ],
            onTap: (index) => context.read<BottomNavigationBloc>().add(
                  PageTapped(index: index),
                ),
          );
        },
      ),
    );
  }

  Widget _getHomePageContent(BuildContext context) {
    return Column(
      children: [_getHomeCalendar(context)],
    );
  }

  Widget _getHomeCalendar(BuildContext context) {
    final _calendarBloc = BlocProvider.of<CalendarBloc>(context);
    DateTime? _selectedDay;

    print(_calendarBloc.focusedDay.subtract(const Duration(days: 3)));
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is CalendarInitial) {
          return TableCalendar<dynamic>(
            firstDay:
                _calendarBloc.focusedDay.subtract(const Duration(days: 3)),
            lastDay: _calendarBloc.focusedDay.add(const Duration(days: 3)),
            focusedDay: _calendarBloc.focusedDay,
            calendarFormat: _calendarBloc.calendarFormat,
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                color: ColorPerseus.pink,
                borderRadius: BorderRadius.circular(20),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              print('onDaySelected');
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                // setState(() {
                //   _selectedDay = selectedDay;
                //   _focusedDay = focusedDay;
                // });
              }
            },
            onFormatChanged: (format) {
              if (_calendarBloc.calendarFormat != format) {
                print('calendar --> onFormatChanged $format');
                _calendarBloc.add(UpdateFormat(calendarFormat: format));
              }
            },
            onPageChanged: (focusedDay) {
              print('onPageChanged');
              // No need to call `setState()` here
              // _calendarBloc.focusedDay = _focusedDay = focusedDay;
            },
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
