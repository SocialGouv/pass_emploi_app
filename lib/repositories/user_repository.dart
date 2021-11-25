import 'dart:convert';

import 'package:http/http.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const USER_KEY = "USER_V2_KEY";

  final String baseUrl;
  final Client httpClient;
  final HeadersBuilder headerBuilder;

  UserRepository(this.baseUrl, this.httpClient, this.headerBuilder);

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonUser = prefs.getString(USER_KEY);
    return jsonUser != null ? User.fromJson(jsonDecode(jsonUser)) : null;
  }

  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_KEY, customJsonEncode(user));
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_KEY);
  }

  Future<User?> logUser(String accessCode) async {
    final url = Uri.parse(baseUrl + "/jeunes/$accessCode/login");
    try {
      final response = await httpClient.post(
        url,
        headers: await headerBuilder.headers(contentType: 'application/json'),
      );
      if (response.statusCode.isValid()) return User.fromJson(jsonUtf8Decode(response.bodyBytes));
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
