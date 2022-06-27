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

extension ParseStringToEnum on Level {
  Level? enumFromString<T>(Iterable<Level> values, String value) {
    return values
        .firstWhere((type) => type.toString().split('.').last == value);
  }
}
