import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:perseus_front_mobile/model/exercise.dart';

class Set extends Equatable {
  const Set(
    this.id,
    this.name,
    this.exercises,
    this.validedAt,
    this.createdAt,
    this.updatedAt, {
    required this.isValided,
  });

  factory Set.fromJson(String source) =>
      Set.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Set.fromMap(Map<String, dynamic> _map) {
    final exercises = <Exercise>[];
    final exercisesMap = _map['exercises'] as List<dynamic>;

    for (final exercise in exercisesMap) {
      exercises.add(Exercise.fromMap(exercise as Map<String, dynamic>));
    }

    return Set(
      _map['id'] as String,
      _map['name'] as String,
      exercises,
      _map['validedAt'] != null
          ? DateTime.parse(_map['validedAt'] as String)
          : null,
      _map['createdAt'] != null
          ? DateTime.parse(_map['createdAt'] as String)
          : DateTime.now(),
      _map['updatedAt'] != null
          ? DateTime.parse(_map['updatedAt'] as String)
          : DateTime.now(),
      isValided: _map['isValided'] as bool,
    );
  }

  final String id;
  final String name;
  final bool isValided;
  final List<Exercise> exercises;

  final DateTime? validedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isValided': isValided,
      'exercises': exercises.map((exercise) => exercise.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap(), toEncodable: datetimeEncode);

  dynamic datetimeEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    } else if (item is Exercise) {
      return item.toJson();
    }
    return item;
  }

  Set copyWith({
    String? id,
    String? name,
    bool? isValided,
    List<Exercise>? exercises,
    DateTime? validedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Set(
      id ?? this.id,
      name ?? this.name,
      exercises ?? this.exercises,
      validedAt ?? this.validedAt,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
      isValided: isValided ?? this.isValided,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      isValided,
      exercises,
      createdAt,
      updatedAt,
    ];
  }

  Future<void> saveToBox(Box<String> setBox) async {
    await setBox.put('data', toJson());
  }
}
