import 'package:flutter/material.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/model/enum/day.dart';
import 'package:perseus_front_mobile/model/enum/level.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension ParseToString on Enum {
  String toShortString() {
    return toString().split('.').last;
  }
}
