// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:perseus_front_mobile/model/exercise_data.dart';

class Exercise extends Equatable {
  const Exercise(this.id, this.name, this.exerciseDataIds, this.exercisesData);

  factory Exercise.fromMap(Map<String, dynamic> _map) {
    final exercisesData = <ExerciseData>[];
    final exercisesDataMap = _map['exerciseData'] as List<dynamic>;

    for (final exerciseData in exercisesDataMap) {
      exercisesData
          .add(ExerciseData.fromMap(exerciseData as Map<String, dynamic>));
    }

    print('exdata: $exercisesData');
    return Exercise(
      _map['id'] as String,
      _map['name'] as String,
      List<String>.from(_map['exerciseDataIds'] as List),
      exercisesData,
    );
  }

  final String id;
  final String name;
  final List<String> exerciseDataIds;
  final List<ExerciseData> exercisesData;

  @override
  List<Object?> get props => [id, name, exerciseDataIds, exercisesData];

  Exercise copyWith({
    String? id,
    String? name,
    List<String>? exerciseDataIds,
    List<ExerciseData>? exercisesData,
  }) {
    return Exercise(
      id ?? this.id,
      name ?? this.name,
      exerciseDataIds ?? this.exerciseDataIds,
      exercisesData ?? this.exercisesData,
    );
  }
}
