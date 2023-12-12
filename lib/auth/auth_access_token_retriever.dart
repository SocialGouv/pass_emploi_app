import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/max_living_time_config.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:synchronized/synchronized.dart';

class AuthAccessTokenRetriever {
  final MaxLivingTimeConfig _maxLivingTimeConfig;
  final Authenticator _authenticator;
  final Lock _lock;
  late Store<AppState> _store;

  AuthAccessTokenRetriever(this._maxLivingTimeConfig, this._authenticator, this._lock);

  Future<String> accessToken() async {
    return _lock.synchronized(() async => _accessToken());
  }

  Future<String> _accessToken() async {
    final idToken = await _authenticator.idToken();
    if (idToken == null) throw Exception("ID Token is null");

    if (idToken.isValid(now: DateTime.now(), maxLivingTimeInSeconds: maxLivingTimeInSeconds(idToken))) {
      return (await _authenticator.accessToken())!;
    }

    final refreshTokenStatus = await _authenticator.performRefreshToken();
    switch (refreshTokenStatus) {
      case RefreshTokenStatus.SUCCESSFUL:
        return (await _authenticator.accessToken())!;
      case RefreshTokenStatus.EXPIRED_REFRESH_TOKEN:
        _store.dispatch(RequestLogoutAction(LogoutReason.expiredRefreshToken));
        throw Exception("Refresh token is expired");
      default:
        throw Exception(refreshTokenStatus);
    }
  }

  int? maxLivingTimeInSeconds(AuthIdToken idToken) {
    if (idToken.getLoginMode().isMiLo()) return _maxLivingTimeConfig.maxLivingTimeInSecondsForMilo();
    return null;
  }

  void setStore(Store<AppState> store) => _store = store;
}
