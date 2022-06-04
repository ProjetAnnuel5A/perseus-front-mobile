import 'package:equatable/equatable.dart';

class ExerciseData extends Equatable {
  ExerciseData(this.id, this.repetition, {required this.isValided});

  ExerciseData.fromMap(Map<String, dynamic> _map)
      : id = _map['id'] as String,
        repetition = _map['repetition'] as int,
        isValided = _map['isValided'] as bool;

  final String id;
  int repetition;
  final bool isValided;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'repetition': repetition,
      'isValided': isValided
    };
  }

  @override
  List<Object?> get props => [id, repetition, isValided];
}
