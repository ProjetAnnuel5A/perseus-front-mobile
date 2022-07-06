import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/interceptor/jwt_interceptor.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/workout.dart';

class WorkoutRepository {
  WorkoutRepository() {
    _baseUrl = dotenv.env['sport_api'] ?? 'locahost:3000';
    _dio.options.headers['content-Type'] = 'application/json';
  }

  String? _baseUrl;
  final Dio _dio = Dio();
  final _storage = SecureStorage();

  Future<List<Workout>> getAllByUserId() async {
    await checkToken();

    final userId = await _storage.getUserId();

    try {
      final response = await _dio.get<String>(
        '$_baseUrl/v1/workouts/byUserId/$userId',
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
      }
    } on DioError catch (e, stackTrace) {
      if (DioErrorType.receiveTimeout == e.type ||
          DioErrorType.connectTimeout == e.type) {
        throw CommunicationTimeoutException(stackTrace);
      } else if (DioErrorType.other == e.type) {
        if (e.message.contains('SocketException')) {
          throw CommunicationTimeoutException(stackTrace);
        }
      }
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 404:
            throw NotFoundException(stackTrace);
        }
      }
    }

    throw InternalServerException(StackTrace.current);
  }

  Future<List<Workout>> getAllPreviousByUserId(DateTime date) async {
    await checkToken();

    final body = jsonEncode(
      <String, dynamic>{'date': date},
      toEncodable: datetimeEncode,
    );

    final userId = await _storage.getUserId();

    try {
      final response = await _dio.post<String>(
        '$_baseUrl/v1/workouts/validatedByUserId/$userId',
        data: body,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 && response.data != null) {
        final workouts = <Workout>[];
        final dataList = jsonDecode(response.data!) as List;

        for (final element in dataList) {
          final map = element as Map<String, dynamic>;
          final workout = Workout.fromMap(map);

          workouts.add(workout);
        }

        return workouts;
      }
    } on DioError catch (e, stackTrace) {
      if (DioErrorType.receiveTimeout == e.type ||
          DioErrorType.connectTimeout == e.type) {
        throw CommunicationTimeoutException(stackTrace);
      } else if (DioErrorType.other == e.type) {
        if (e.message.contains('SocketException')) {
          throw CommunicationTimeoutException(stackTrace);
        }
      }
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 404:
            throw NotFoundException(stackTrace);
        }
      }
    }

    throw InternalServerException(StackTrace.current);
  }

  Future<void> validateWorkout(String workoutId) async {
    await checkToken();

    try {
      final response = await _dio.patch<String>(
        '$_baseUrl/v1/workouts/validateWorkout/$workoutId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return;
      }
    } catch (e, stackTrace) {
      if (e is DioError && e.response != null) {
        switch (e.response!.statusCode) {
          case 404:
            throw NotFoundException(stackTrace);
        }
      }
    }

    throw InternalServerException(StackTrace.current);
  }

  Future<void> checkToken() async {
    if (_dio.interceptors.isEmpty) {
      final token = await _storage.getToken();

      if (token != null) {
        _dio.interceptors.add(CustomInterceptors(token));
      }
    }
  }

  dynamic datetimeEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}
