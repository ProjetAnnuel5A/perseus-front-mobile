import 'package:flutter/material.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/model/enum/day.dart';
import 'package:perseus_front_mobile/model/enum/level.dart';
import 'package:perseus_front_mobile/model/enum/objective.dart';

String translateDay(BuildContext context, Day day) {
  final l10n = context.l10n;

  switch (day) {
    case Day.MONDAY:
      return l10n.monday;
    case Day.TUESDAY:
      return l10n.tuesday;
    case Day.WEDNESDAY:
      return l10n.wednesday;
    case Day.THURSDAY:
      return l10n.thursday;
    case Day.FRIDAY:
      return l10n.friday;
    case Day.SATURDAY:
      return l10n.saturday;
    case Day.SUNDAY:
      return l10n.sunday;
  }
}

String translateLevel(BuildContext context, Level level) {
  final l10n = context.l10n;

  switch (level) {
    case Level.ADVANCED:
      return l10n.advanced;
    case Level.BEGINNER:
      return l10n.beginner;
    case Level.INTERMEDIATE:
      return l10n.intermediate;
  }
}

String translateObjective(BuildContext context, Objective objective) {
  final l10n = context.l10n;

  switch (objective) {
    case Objective.GAIN:
      return l10n.gain;
    case Objective.LOSE:
      return l10n.lose;
    case Objective.MAINTAIN:
      return l10n.maintain;
  }
}
