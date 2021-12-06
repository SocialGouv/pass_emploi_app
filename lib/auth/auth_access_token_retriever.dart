import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

// TODO-115 : test
class AuthAccessTokenRetriever {
  final Authenticator _authenticator;
  final Store<AppState> _store;

  AuthAccessTokenRetriever(this._authenticator, this._store);

  Future<String> accessToken() async {
    final idToken = _authenticator.idToken();
    if (idToken == null) throw Exception("ID Token is null");
    if (idToken.isValid()) return _authenticator.accessToken()!;
    switch (await _authenticator.refreshToken()) {
      case RefreshTokenStatus.SUCCESSFUL:
        return _authenticator.accessToken()!;
      case RefreshTokenStatus.EXPIRED_REFRESH_TOKEN:
        _store.dispatch(LogoutAction());
        throw Exception("ID Token is null");
      default:
        throw Exception(await _authenticator.refreshToken());
    }
  }
}
