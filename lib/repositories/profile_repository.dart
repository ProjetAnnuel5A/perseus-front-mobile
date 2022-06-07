import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseus_front_mobile/model/profile.dart';

class ProfileRepository {
  static const server = 'https://pa5a.herokuapp.com';

  Future<Profile?> getById(String profileId, String jwt) async {
    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $jwt';

    try {
      final response = await dio.get<String>(
        '$server/api/profiles/$profileId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final profileMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final profile = Profile.fromMap(profileMap);

        return profile;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
