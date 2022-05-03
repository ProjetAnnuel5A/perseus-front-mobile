import 'package:badges/badges.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/extensions.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:perseus_front_mobile/pages/counter/counter.dart';
import 'package:perseus_front_mobile/pages/home/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:perseus_front_mobile/pages/home/bloc/calendar/calendar_bloc.dart';
import 'package:perseus_front_mobile/repositories/workout_repository.dart';
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
          create: (BuildContext context) =>
              CalendarBloc(context.read<WorkoutRepository>()),
        ),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  Map<DateTime, List<Workout>> selectedWorkouts = {};

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
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Board',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.run_circle),
                label: 'Running',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  badgeContent:
                      const Text('3', style: TextStyle(color: Colors.white)),
                  child: const Icon(Icons.notifications),
                ),
                label: 'Notification',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Reglage',
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
      children: [_getHomeCalendar(context), _getWorkouts(context)],
    );
  }

  Widget _getHomeCalendar(BuildContext context) {
    final _calendarBloc = BlocProvider.of<CalendarBloc>(context);

    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is CalendarLoaded) {
          for (final workout in _calendarBloc.workouts) {
            selectedWorkouts[workout.date] = [workout];
          }

          return TableCalendar<Workout>(
            firstDay: _calendarBloc.firstDay,
            lastDay: _calendarBloc.lastDay,
            focusedDay: _calendarBloc.focusedDay,
            calendarFormat: _calendarBloc.calendarFormat,
            eventLoader: _getEventsfromDay,
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                color: ColorPerseus.pink,
                borderRadius: BorderRadius.circular(20),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            selectedDayPredicate: (DateTime date) {
              return isSameDay(_calendarBloc.selectedDay, date);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_calendarBloc.selectedDay, selectedDay)) {
                _calendarBloc.add(SelectDay(selectedDay: selectedDay));
              }
            },
            onFormatChanged: (format) {
              if (_calendarBloc.calendarFormat != format) {
                _calendarBloc.add(UpdateFormat(calendarFormat: format));
              }
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Workout> _getEventsfromDay(DateTime date) {
    var result = <Workout>[];

    selectedWorkouts.forEach((key, workout) {
      if (key.isSameDay(date) && selectedWorkouts[key] != null) {
        result = selectedWorkouts[key]!;
      }
    });

    return result;
  }

  Widget _getWorkouts(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        final selectedDay = context.read<CalendarBloc>().selectedDay;
        final size = MediaQuery.of(context).size;

        if (state is CalendarLoaded) {
          // TODO One workout /day ?
          final workoutOfSelectedDay = state.workouts.firstWhereOrNull(
            (Workout workout) => workout.date.isSameDay(selectedDay),
          );

          return Expanded(
              child: Column(
            children: [
              sample(),
              workoutCard(
                  context, Workout("id", "Pull", 120, DateTime.now(), []))
            ],
          ));

          return workoutCard(
              context, Workout("id", "Pull", 120, DateTime.now(), []));

          if (workoutOfSelectedDay != null) {
            return workoutCard(context, workoutOfSelectedDay);
          }

          return const Text('No data');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Widget workoutCard(BuildContext context, Workout workout) {
    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Color(0xFF6F56E8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(68),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  workout.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Legs Toning and\nGlutes Workout at Home',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                ),
                exercisesSample(),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.timer,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          '${workout.time} min',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(8, 8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/exercise',
                          ),
                          icon: const Icon(
                            Icons.arrow_right,
                            color: Color(0xFF6F56E8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget exercisesSample() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: const [
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with both widgets'),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with both widgets'),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with both widgets'),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
        ],
      ),
    );
  }

  Widget sample() {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8),),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: Image.asset('images/back.png'),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 100,
                                  right: 16,
                                  top: 16,
                                ),
                                child: Text(
                                  "You're doing great!",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 100,
                              bottom: 12,
                              top: 4,
                              right: 16,
                            ),
                            child: Text(
                              'Keep it up\nand stick to your plan!',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                letterSpacing: 0,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -16,
                left: 0,
                child: SizedBox(
                  width: 110,
                  height: 110,
                  child: Image.asset('images/runner.png'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
