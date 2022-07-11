import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/extensions.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/common/widget/gradient_progress_indicator_widget.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/model/set.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:perseus_front_mobile/pages/home/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:perseus_front_mobile/pages/home/bloc/calendar/calendar_bloc.dart';
import 'package:perseus_front_mobile/pages/notification/view/notification_page.dart';
import 'package:perseus_front_mobile/pages/profile/view/profile_page.dart';
import 'package:perseus_front_mobile/pages/settings/view/settings_page.dart';
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

    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (BuildContext context, BottomNavigationState state) {
            if (state is PageLoading) {
              return customLoader(context);
            } else if (state is BottomNavigationInitial) {
              return _getHomePageContent(context);
            } else if (state is PageLoaded) {
              if (state.currentIndex == 0) {
                return const ProfilePage();
              } else if (state.currentIndex == 1) {
                return _getHomePageContent(context);
              } else if (state.currentIndex == 3) {
                return const NotificationPage();
              } else if (state.currentIndex == 2) {
                return const SettingsPage();
              } else {
                // return ?;
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
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: l10n.profile,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.calendar_month),
                  label: l10n.calendar,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: l10n.settings,
                ),
              ],
              onTap: (index) => context.read<BottomNavigationBloc>().add(
                    PageTapped(index: index),
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _getHomePageContent(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is CalendarLoaded) {
          return Column(
            children: [
              if (state.isOffline == true) _offlineBanner(context),
              _getHomeCalendar(context),
              _getWorkouts(context, state.workouts)
            ],
          );
        } else if (state is CalendarError) {
          return showError(context, state);
        }

        return customLoader(context);
      },
    );
  }

  Widget _getHomeCalendar(BuildContext context) {
    final l10n = context.l10n;
    final _calendarBloc = BlocProvider.of<CalendarBloc>(context);

    for (final workout in _calendarBloc.workouts) {
      selectedWorkouts[workout.date] = [workout];
    }

    return TableCalendar<Workout>(
      availableCalendarFormats: {
        CalendarFormat.month: l10n.month,
        CalendarFormat.twoWeeks: l10n.twoWeeks,
        CalendarFormat.week: l10n.week,
      },
      locale: Localizations.localeOf(context).languageCode,
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

  List<Workout> _getEventsfromDay(DateTime date) {
    var result = <Workout>[];

    selectedWorkouts.forEach((key, workout) {
      if (key.isSameDay(date) && selectedWorkouts[key] != null) {
        result = selectedWorkouts[key]!;
      }
    });

    return result;
  }

  Widget _getWorkouts(BuildContext context, List<Workout> workouts) {
    final selectedDay = context.read<CalendarBloc>().selectedDay;

    final workoutOfSelectedDay = workouts.firstWhereOrNull(
      (Workout workout) => workout.date.isSameDay(selectedDay),
    );

    if (workoutOfSelectedDay != null) {
      return Expanded(
        child: Column(
          children: [
            keepItUpBanner(context),
            workoutCard(context, workoutOfSelectedDay)
          ],
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          const Spacer(),
          Text(context.l10n.noWorkoutToday),
          Image.asset('assets/images/rest.png'),
          const Spacer(),
        ],
      ),
    );
  }

  Widget workoutCard(BuildContext context, Workout workout) {
    final l10n = context.l10n;

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
                  '${l10n.workout}: ${workout.name}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 18),
                _set(workout.sets, workout.date),
                const SizedBox(
                  height: 18,
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
                          '${workout.estimatedTime} min',
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
                          color:
                              workout.isValided ? Colors.white70 : Colors.white,
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
                          onPressed: workout.isValided
                              ? null
                              : () {
                                  confirmationDialog(context, workout.id);
                                },
                          icon: Icon(
                            Icons.check,
                            color: workout.isValided
                                ? const Color(0xFF008000)
                                : const Color(0xFF6F56E8),
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

  Widget _set(List<Set> sets, DateTime workoutDate) {
    if (sets.isEmpty) {
      return const SizedBox.shrink();
    }

    sets.sort((set1, set2) {
      return set1.name.toLowerCase().compareTo(set2.name.toLowerCase());
    });

    return Expanded(
      child: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.fitness_center,
                color: sets[index].isValided ? Colors.green : Colors.red,
              ),
              title: Text(sets[index].name),
              trailing: IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/set',
                    arguments: {'set': sets[index], 'workoutDate': workoutDate},
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget keepItUpBanner(BuildContext context) {
    final l10 = context.l10n;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
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
                      topRight: Radius.circular(8),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: Image.asset('assets/images/back.png'),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 100,
                                  right: 16,
                                  top: 16,
                                ),
                                child: Text(
                                  l10.youAreDoingGreat,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
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
                              l10.keepItUp,
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
                  child: Image.asset('assets/images/runner.png'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<String?> confirmationDialog(
    BuildContext blocContext,
    String workoutId,
  ) {
    return showCupertinoDialog<String>(
      context: blocContext,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(context.l10n.confirmation),
          content: Text(
            context.l10n.validateWorkoutQuestion,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(context.l10n.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(context.l10n.yes),
              onPressed: () {
                blocContext
                    .read<CalendarBloc>()
                    .add(ValidateWorkout(workoutId: workoutId));
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  GradientProgressIndicator customLoader(BuildContext context) {
    return GradientProgressIndicator(
      gradientColors: [
        Colors.white,
        ColorPerseus.pink,
      ],
      child: Text(
        '${context.l10n.loading}...',
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  Widget showError(BuildContext context, CalendarError state) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarError(context, state.httpException),
      );
    });
    return Center(
      child: Column(
        children: [
          const Spacer(),
          _errorImage(),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(ColorPerseus.pink),
              padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 20),
              ),
            ),
            onPressed: () {
              context.read<CalendarBloc>().add(CalendarStarted());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.reload),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.refresh,
                  size: 30,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _errorImage() {
    return SizedBox(
      child: Image.asset('assets/images/exception.png'),
    );
  }

  SnackBar snackBarError(BuildContext context, HttpException httpException) {
    final snackBar = SnackBar(
      backgroundColor: ColorPerseus.blue,
      content: Text(translateErrorMessage(context, httpException)),
      action: SnackBarAction(
        label: context.l10n.close,
        textColor: ColorPerseus.pink,
        onPressed: () {},
      ),
    );

    return snackBar;
  }

  String translateErrorMessage(
    BuildContext context,
    HttpException httpException,
  ) {
    if (httpException is InternalServerException) {
      return httpException.getTranslatedMessage(context);
    } else if (httpException is CommunicationTimeoutException) {
      return httpException.getTranslatedMessage(context);
    }

    return context.l10n.unknownException;
  }

  Widget _offlineBanner(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      color: ColorPerseus.pink,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.save),
              color: Colors.white,
              onPressed: () {
                context.read<CalendarBloc>().add(SaveOfflineWorkouts());
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  context.l10n.offline,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                context.read<CalendarBloc>().add(ReloadCache());
              },
            ),
          ],
        ),
      ),
    );
  }
}
