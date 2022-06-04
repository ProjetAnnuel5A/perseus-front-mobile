import 'package:perseus_front_mobile/model/difficulty.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension ParseToString on Difficulty {
  String toShortString() {
    return toString().split('.').last;
  }
}
