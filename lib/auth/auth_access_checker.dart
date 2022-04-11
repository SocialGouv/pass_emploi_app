import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AuthAccessChecker {
  late Store<AppState> _store;

  void logoutUserIfTokenIsExpired(String? message, int statusCode) {
    if (message == 'token_pole_emploi_expired' && statusCode == 401) {
      _store.dispatch(RequestLogoutAction());
    }
  }

  void setStore(Store<AppState> store) => _store = store;
}
