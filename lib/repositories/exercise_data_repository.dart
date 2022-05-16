import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseus_front_mobile/model/exercise_data.dart';

class ExerciseDataRepository {
  static const server = 'http://localhost:3000';

  Future<String?> updateExercisesData(
    List<ExerciseData> exercisesData,
  ) async {
    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final body = jsonEncode(
      <String, List<ExerciseData>>{'updateExercisesDataDto': exercisesData},
    );

    // todo remove bad code

    try {
      final response = await dio.post<String>(
        '$server/exercises-data/update-multiple',
        data: body,
      );
    } catch (e) {
      print(e);
    }

    return '';
  }
}
