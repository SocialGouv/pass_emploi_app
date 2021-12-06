import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _configuration = Configuration(
  'serverBaseUrl',
  'firebaseEnvironmentPrefix',
  'matomoBaseUrl',
  'matomoSiteId',
  'authClientId',
  'authLoginRedirectUrl',
  'authIssuer',
  ['scope1', 'scope2', 'scope3'],
  'authClientSecret',
);

class AccessTokenInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final updatedData = await _checkAccessToken(data);
    return updatedData ?? data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

Future<RequestData?> _checkAccessToken(RequestData data) async {
  // TODO-115 avec authenticator, récuperer l'ID TOKEN
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  final AuthWrapper _authWrapper = AuthWrapper(_appAuth);
  final Authenticator _auth = Authenticator(_authWrapper, _configuration, _prefs);

  final idToken = _auth.idToken();
  // TODO-115 avec l'ID TOKEN checker si valid (commme dans le POC)
  if (idToken != null) {
    if (idToken!.isValid()) {
      // TODO-115 si ID TOKEN pas périmé, envoyer l'acccess token en HEADER (data.headers[""]
      data = _setHeader(data: data, token: _auth.accessToken());
      // TODO-115 si ID TOKEN périmé, faire un refresh token, puis envoyer l'acccess token en HEADER (data.headers[""]
    } else {
      await _auth.refreshToken().then((tokenStatus) {
        // TODO-115 si erreur NETWORK_UNREACHABLE, ???? (lancer une exception ???)
        if (tokenStatus == RefreshTokenStatus.NETWORK_UNREACHABLE)
          throw Exception(Strings.loginError);
        // TODO-115 si erreur EXPIRED_REFRESH_TOKEN, envoyer une Action qui va remettre le LoginState à notLoggedIn (et lancer une exception ???)
        else if (tokenStatus == RefreshTokenStatus.EXPIRED_REFRESH_TOKEN){
          throw Exception(Strings.loginError);
        }
        else if (tokenStatus == RefreshTokenStatus.SUCCESSFUL)
          data = _setHeader(data: data, token: _auth.accessToken());
      });
    }
    return data;
  }
}

RequestData _setHeader({required RequestData data, required String? token}) {
  final String accessToken = token ?? "";
  if (accessToken.isNotEmpty) {
    Map<String, String> headers = {"authorization": accessToken};
    data.headers.addAll(headers);
  }
  return data;
}
