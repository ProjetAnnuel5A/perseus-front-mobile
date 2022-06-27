import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/interceptor/jwt_interceptor.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/dto/validate_set_dto.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/set.dart';

class SetRepository {
  SetRepository() {
    _baseUrl = dotenv.env['sport_api'] ?? 'locahost:3000';
    _dio.options.headers['content-Type'] = 'application/json';
  }
  String? _baseUrl;
  final Dio _dio = Dio();
  final _storage = SecureStorage();

  Future<Set> validateSet(String setId, List<Exercise> exercises) async {
    await checkToken();

    final data = ValidateSetDto(exercises).toJson();

    try {
      final response = await _dio.patch<String>(
        '$_baseUrl/v1/sets/validate/$setId',
        data: data,
      );

      if (response.statusCode == 200 && response.data != null) {
        final setMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final set = Set.fromMap(setMap);

        return set;
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

  Future<Set> getById(String setId) async {
    await checkToken();

    try {
      final response = await _dio.get<String>(
        '$_baseUrl/v1/sets/$setId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final setMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final set = Set.fromMap(setMap);

        return set;
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
}
