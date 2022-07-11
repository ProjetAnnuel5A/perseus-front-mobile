import 'dart:convert';

import 'package:perseus_front_mobile/model/workout.dart';

class OfflineDto {
  OfflineDto(this.workouts);

  final List<Workout> workouts;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'workouts': workouts.map((workout) => workout.toMap()).toList(),
      };

  String toJson() => json.encode(toMap(), toEncodable: datetimeEncode);

  dynamic datetimeEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}
