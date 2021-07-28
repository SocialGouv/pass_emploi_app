import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const USER_ID_KEY = "USER_ID_KEY";

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_ID_KEY);
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ID_KEY, userId);
  }
}
