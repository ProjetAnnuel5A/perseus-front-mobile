import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseus_front_mobile/model/dto/profile_update_dto.dart';
import 'package:perseus_front_mobile/model/profile.dart';

class ProfileRepository {
  static const server = 'https://pa5a.herokuapp.com';

  Future<Profile?> getById(String profileId, String jwt) async {
    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $jwt';

    try {
      final response = await dio.get<String>(
        '$server/v1/api/profiles/$profileId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final profileMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final profile = Profile.fromMap(profileMap);

        print(profile);

        return profile;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<void> update(
    String profileId,
    ProfileUpdateDto profileUpdateDto,
    String jwt,
  ) async {
    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $jwt';

    final data = profileUpdateDto.toJson();

    try {
      final response = await dio.patch<String>(
        '$server/v1/api/profiles/$profileId',
        data: data,
      );

      if (response.statusCode == 200) {
        return;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
  }
}
