// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:perseus_front_mobile/model/difficulty.dart';

class Exercise extends Equatable {
  Exercise(
    this.id,
    this.name,
    this.description,
    this.repetition,
    this.weight,
    this.calorie,
    this.difficulty,
    this.createdAt,
    this.updatedAt,
  );

  factory Exercise.fromMap(Map<String, dynamic> _map) {
    return Exercise(
      _map['id'] as String,
      _map['name'] as String,
      _map['description'] as String,
      _map['repetition'] as int,
      _map['weight'] as int,
      _map['calorie'] as int,
      Difficulty.values[_map['difficulty'] as int],
      DateTime.parse(_map['createdAt'] as String),
      DateTime.parse(_map['updatedAt'] as String),
    );
  }

  final String id;
  final String name;
  final String description;
  int repetition;
  final int weight;
  final int calorie;
  final Difficulty difficulty;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    int? repetition,
    int? weight,
    int? calorie,
    Difficulty? difficulty,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      repetition ?? this.repetition,
      weight ?? this.weight,
      calorie ?? this.calorie,
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
      description,
      repetition,
      weight,
      calorie,
      difficulty,
      createdAt,
      updatedAt,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'descritpion': description,
      'repetition': repetition,
      'weight': weight,
      'calorie': calorie,
      'difficulty': difficulty.index,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String toJson() => json.encode(toMap(), toEncodable: datetimeEncode);

  dynamic datetimeEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source) as Map<String, dynamic>);
}
