import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:redux/redux.dart';

class AuthAccessChecker {
  late Store<AppState> _store;

  void logoutUserIfTokenIsExpired(String? message, int statusCode) {
    if (message?.containsExpiredToken() == true || statusCode == 401) {
      Log.i("Logout user on token expired: $message.");
      _store.dispatch(RequestLogoutAction(LogoutReason.apiResponse401));
    }
  }

  void setStore(Store<AppState> store) => _store = store;
}

extension _StringExtension on String {
  bool containsExpiredToken() {
    return contains("token_pole_emploi_expired") || contains("token_milo_expired") || contains("auth_user_not_found");
  }
}
