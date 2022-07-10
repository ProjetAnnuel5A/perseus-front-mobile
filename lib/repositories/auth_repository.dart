import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/model/dto/register_dto.dart';

class AuthRepository {
  AuthRepository() {
    _baseUrl = dotenv.env['login_api'] ?? 'locahost:9090';
    _dio.options.headers['content-Type'] = 'application/json';
  }

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: 3000,
      receiveTimeout: 3000,
    ),
  );
  String? _baseUrl;

  Future<void> register(RegisterDto registerDto) async {
    final data = registerDto.toJson();

    try {
      final response = await _dio.post<String>(
        '$_baseUrl/v1/auth/register',
        data: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return;
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
          case 403:
            throw ForbiddenException(stackTrace);
          case 404:
            throw NotFoundException(stackTrace);
          case 409:
            throw ConflictException(stackTrace);
        }
      }
    }

    throw InternalServerException(StackTrace.current);
  }

  Future<String> login(String username, String password) async {
    final body = jsonEncode(
      <String, String>{'username': username, 'password': password},
    );

    try {
      final response =
          await _dio.post<dynamic>('$_baseUrl/v1/auth/login', data: body);

      if (response.statusCode == 201) {
        final header = response.headers['authorization'];

        if (header != null) {
          final token = header[0].substring(7);

          return token;
        }
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
          case 403:
            throw ForbiddenException(stackTrace);
          case 404:
            throw NotFoundException(stackTrace);
        }
      }
    }

    throw InternalServerException(StackTrace.current);
  }
}
