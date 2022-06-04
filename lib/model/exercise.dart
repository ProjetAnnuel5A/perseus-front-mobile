// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/extensions.dart';

import 'package:perseus_front_mobile/model/difficulty.dart';

class Exercise extends Equatable {
  Exercise(
    this.id,
    this.name,
    this.repetition,
    this.difficulty,
    this.createdAt,
    this.updatedAt,
  );

  factory Exercise.fromMap(Map<String, dynamic> _map) {
    return Exercise(
      _map['id'] as String,
      _map['name'] as String,
      _map['repetition'] as int,
      Difficulty.values.byName(_map['difficulty'] as String),
      DateTime.parse(_map['createdAt'] as String),
      DateTime.parse(_map['updatedAt'] as String),
    );
  }

  final String id;
  final String name;
  int repetition;
  final Difficulty difficulty;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exercise copyWith({
    String? id,
    String? name,
    int? repetition,
    Difficulty? difficulty,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id ?? this.id,
      name ?? this.name,
      repetition ?? this.repetition,
      difficulty ?? this.difficulty,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      repetition,
      difficulty,
      createdAt,
      updatedAt,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'repetition': repetition,
      'difficulty': difficulty.toShortString(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source) as Map<String, dynamic>);
}
