import 'package:http_interceptor/http_interceptor.dart';

class AccessTokenInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // TODO-115 avec authenticator, récuperer l'ID TOKEN
    // TODO-115 avec l'ID TOKEN checker si valid (commme dans le POC)
    // TODO-115 si ID TOKEN pas périmé, envoyer l'acccess token en HEADER (data.headers[""]
    // TODO-115 si ID TOKEN périmé, faire un refresh token, puis envoyer l'acccess token en HEADER (data.headers[""]
    // TODO-115 si erreur NETWORK_UNREACHABLE, ???? (lancer une exception ???)
    // TODO-115 si erreur EXPIRED_REFRESH_TOKEN, envoyer une Action qui va remettre le LoginState à notLoggedIn (et lancer une exception ???)
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
