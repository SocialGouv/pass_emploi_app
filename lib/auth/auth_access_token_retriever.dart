import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class AuthAccessTokenRetriever {
  final Authenticator _authenticator;
  late Store<AppState> _store;

  AuthAccessTokenRetriever(this._authenticator);

  Future<String> accessToken() async {
    final idToken = _authenticator.idToken();
    if (idToken == null) throw Exception("ID Token is null");
    if (idToken.isValid()) return _authenticator.accessToken()!;
    final refreshTokenStatus = await _authenticator.refreshToken();
    switch (refreshTokenStatus) {
      case RefreshTokenStatus.SUCCESSFUL:
        return _authenticator.accessToken()!;
      case RefreshTokenStatus.EXPIRED_REFRESH_TOKEN:
        _store.dispatch(RequestLogoutAction(LogoutRequester.SYSTEM));
        throw Exception("ID Token is null");
      default:
        throw Exception(refreshTokenStatus);
    }
  }

  void setStore(Store<AppState> store) => _store = store;
}
