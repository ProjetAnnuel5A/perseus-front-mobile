// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:perseus_front_mobile/model/set.dart';

class Workout extends Equatable {
  const Workout(
    this.id,
    this.name,
    this.description,
    this.estimatedTime,
    this.date,
    this.userId,
    this.sets,
    this.validedAt,
    this.createdAt,
    this.updatedAt, {
    required this.isValided,
  });

  // factory Workout.fromMapJson(Map<String, dynamic> _map) {
  //   final sets = <Set>[];
  //   final setsMap = _map['sets'] as List<dynamic>;

  //   for (final setMap in setsMap) {
  //     final set = Set.fromMap(setMap as Map<String, dynamic>);
  //     sets.add(set);
  //   }

  //   return Workout(
  //     _map['id'] as String,
  //     _map['name'] as String,
  //     _map['description'] as String,
  //     _map['estimatedTime'] as int,
  //     DateTime.parse(_map['date'] as String),
  //     _map['userId'] as String,
  //     sets,
  //     _map['validedAt'] != null
  //         ? DateTime.parse(_map['validedAt'] as String)
  //         : null,
  //     DateTime.parse(_map['createdAt'] as String),
  //     DateTime.parse(_map['updatedAt'] as String),
  //     isValided: _map['isValided'] as bool,
  //   );
  // }

  factory Workout.fromMap(Map<String, dynamic> _map) {
    final sets = <Set>[];
    final setsMap = _map['sets'] as List<dynamic>;

    for (final set in setsMap) {
      sets.add(Set.fromMap(set as Map<String, dynamic>));
    }

    return Workout(
      _map['id'] as String,
      _map['name'] as String,
      _map['description'] as String,
      _map['estimatedTime'] as int,
      DateTime.parse(_map['date'] as String),
      _map['userId'] as String,
      sets,
      _map['validedAt'] != null
          ? DateTime.parse(_map['validedAt'] as String)
          : null,
      DateTime.parse(_map['createdAt'] as String),
      DateTime.parse(_map['updatedAt'] as String),
      isValided: _map['isValided'] as bool,
    );
  }

  final String id;
  final String name;
  final String description;
  final int estimatedTime;
  final DateTime date;
  final String userId;
  final bool isValided;
  final List<Set> sets;

  final DateTime? validedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workout copyWith({
    String? id,
    String? name,
    String? description,
    int? estimatedTime,
    DateTime? date,
    String? userId,
    bool? isValided,
    List<Set>? sets,
    DateTime? validedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workout(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      estimatedTime ?? this.estimatedTime,
      date ?? this.date,
      userId ?? this.userId,
      sets ?? this.sets,
      validedAt ?? this.validedAt,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
      isValided: isValided ?? this.isValided,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'estimatedTime': estimatedTime,
      'date': date,
      'userId': userId,
      'isValided': isValided,
      'sets': sets.map((set) => set.toMap()).toList(),
      'validedAt': validedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };

    return result;
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      description,
      estimatedTime,
      date,
      userId,
      isValided,
      sets,
      createdAt,
      updatedAt,
    ];
  }

  String toJson() => json.encode(toMap(), toEncodable: datetimeEncode);

  dynamic datetimeEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    } else if (item is Set) {
      return item.toJson();
    }
    return item;
  }

  factory Workout.fromJson(String source) =>
      Workout.fromMap(json.decode(source) as Map<String, dynamic>);
}
