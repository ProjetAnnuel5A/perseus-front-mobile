import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/interceptor/jwt_interceptor.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/dto/profile_update_dto.dart';
import 'package:perseus_front_mobile/model/profile.dart';

class ProfileRepository {
  ProfileRepository() {
    _baseUrl = dotenv.env['login_api'] ?? 'locahost:9090';
    _dio.options.headers['content-Type'] = 'application/json';
  }
  String? _baseUrl;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: 3000,
      receiveTimeout: 3000,
    ),
  );
  final _storage = SecureStorage();

  Future<Profile> getById(String profileId) async {
    await checkToken();

    try {
      final response = await _dio.get<String>(
        '$_baseUrl/v1/api/profiles/$profileId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final profileMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final profile = Profile.fromMap(profileMap);

        return profile;
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

  Future<void> update(
    String profileId,
    ProfileUpdateDto profileUpdateDto,
  ) async {
    await checkToken();

    final data = profileUpdateDto.toJson();

    try {
      final response = await _dio.patch<String>(
        '$_baseUrl/v1/api/profiles/$profileId',
        data: data,
      );

      if (response.statusCode == 200) {
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
          case 404:
            throw NotFoundException(stackTrace);
        }
      }
    }

    throw InternalServerException(StackTrace.current);
  }

  Future<void> deleteProfile() async {
    await checkToken();

    final profileId = await _storage.getUserId();

    if (profileId != null) {
      try {
        final response = await _dio.delete<String>(
          '$_baseUrl/v1/api/profiles/$profileId',
        );

        if (response.statusCode == 204 && response.data != null) {
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
            case 404:
              throw NotFoundException(stackTrace);
          }
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
