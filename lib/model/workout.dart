// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:perseus_front_mobile/model/exercises.dart';

class Workout extends Equatable {
  const Workout(this.id, this.name, this.time, this.date, this.exercises);

  factory Workout.fromMap(Map<String, dynamic> _map) {
    final List<Exercise> exercises = [];

    return Workout(_map['id'] as String, _map['name'] as String,
        _map['time'] as int, DateTime.parse(_map['date'] as String), exercises);
  }

  // : id = _map['id'] as String,
  //   name = _map['name'] as String,
  //   time = _map['time'] as int,
  //   date = DateTime.parse(_map['date'] as String),
  //   exercises = List<Exercise>.from(
  //     (_map['exercises'] as List).map<dynamic>((exercise) => Exercise.fromMap(exercise)))
  //   );

// Map<String, dynamic> toJson() => <String, dynamic>{
//         'name': name,
//         'isEnabled': isEnabled,
//       };

  // messages = List<Message>.from(
  // (map['messages'] as List).map((x) => Message.fromMap(x))),

  final String id;
  final String name;
  final int time;
  final DateTime date;
  final List<Exercise> exercises;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'time': time,
      'date': date,
      'exercises': exercises
    };
  }

  @override
  List<Object?> get props => [name, time, date, exercises];

  Workout copyWith({
    String? id,
    String? name,
    int? time,
    DateTime? date,
    List<Exercise>? exercises,
  }) {
    return Workout(
      id ?? this.id,
      name ?? this.name,
      time ?? this.time,
      date ?? this.date,
      exercises ?? this.exercises,
    );
  }
}
