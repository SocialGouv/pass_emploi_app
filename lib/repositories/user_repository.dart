import 'package:pass_emploi_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const USER_ID_KEY = "USER_ID_KEY";
  static const USER_KEY = "USER_KEY";

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_ID_KEY);
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ID_KEY, userId);
  }

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonUser = prefs.getString(USER_KEY);
    return jsonUser != null ? User.fromJson(jsonUser) : null;
  }
}
