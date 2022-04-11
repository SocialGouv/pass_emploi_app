import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_token_repository.dart';

class AccessTokenInterceptor implements InterceptorContract {
  final AuthAccessTokenRetriever _accessTokenRetriever;
  final PoleEmploiTokenRepository _poleEmploiTokenRepository;

  AccessTokenInterceptor(this._accessTokenRetriever, this._poleEmploiTokenRepository);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // TODO remove
    return data;
    data.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";
    // TODO: temp solution to remove when token would be handled by backend
    final poleEmploiAccessToken = _poleEmploiTokenRepository.getPoleEmploiAccessToken();
    if (poleEmploiAccessToken != null) {
      data.headers["x-idp-token"] = poleEmploiAccessToken;
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
