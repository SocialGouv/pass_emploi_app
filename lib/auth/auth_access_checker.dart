import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:redux/redux.dart';

class AuthAccessChecker {
  late Store<AppState> _store;

  void logoutUserIfTokenIsExpired(String? message, int statusCode) {
    if (message?.contains('token_pole_emploi_expired') == true && statusCode == 401) {
      Log.i("Logout user on token_pole_emploi_expired.");
      _store.dispatch(RequestLogoutAction());
    }
  }

  void setStore(Store<AppState> store) => _store = store;
}
