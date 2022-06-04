import 'dart:convert';

import 'package:perseus_front_mobile/model/exercise.dart';

class ValidateSetDto {
  ValidateSetDto(this.exercises);

  final List<Exercise> exercises;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'exercises': exercises.map((exercise) => exercise.toMap()).toList(),
      };

  String toJson() => json.encode(toMap());
}
