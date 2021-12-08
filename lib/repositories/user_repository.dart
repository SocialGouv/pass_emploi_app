import 'dart:convert';

import 'package:http/http.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO-115: delete
class UserRepository {
  static const USER_KEY = "USER_V2_KEY";

  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;

  UserRepository(this._baseUrl, this._httpClient, this._headerBuilder);

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

  // TODO-115: still required for the backend ???
  Future<User?> logUser(String accessCode) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$accessCode/login");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headerBuilder.headers(contentType: 'application/json'),
      );
      if (response.statusCode.isValid()) return User.fromJson(jsonUtf8Decode(response.bodyBytes));
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
