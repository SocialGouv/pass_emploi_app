import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const USER_KEY = "USER_KEY";

  final String baseUrl;

  UserRepository(this.baseUrl);

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonUser = prefs.getString(USER_KEY);
    return jsonUser != null ? User.fromJson(jsonDecode(jsonUser)) : null;
  }

  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_KEY, customJsonEncode(user.toJson()));
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_KEY);
  }

  Future<User?> logUser(String firstName, String lastName) async {
    final user = User(id: _generateUserId(), firstName: firstName, lastName: lastName);
    var url = Uri.parse(baseUrl + "/jeunes");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: customJsonEncode(PostUserRequest(user: user)),
      );
      if (response.statusCode.isValid()) return user;
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }

  _generateUserId() => DateTime.now().hashCode.toString();
}
