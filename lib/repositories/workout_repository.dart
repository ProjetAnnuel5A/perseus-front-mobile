import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseus_front_mobile/model/workout.dart';

class WorkoutRepository {
  static const server = 'http://localhost:3000';

  Future<List<Workout>> getAll() async {
    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    try {
      final response = await dio.get<String>(
        '$server/v1/workouts/',
      );

      if (response.statusCode == 200 && response.data != null) {
        final workouts = <Workout>[];
        final dataList = jsonDecode(response.data!) as List;

        for (final element in dataList) {
          final map = element as Map<String, dynamic>;
          final workout = Workout.fromMap(map);

          workouts.add(workout);
        }

        return workouts;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return [];
  }
}
