import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_token_repository.dart';

class AccessTokenInterceptor implements InterceptorContract {
  final AuthAccessTokenRetriever _accessTokenRetriever;
  final PoleEmploiTokenRepository _poleEmploiTokenRepository;

  AccessTokenInterceptor(this._accessTokenRetriever, this._poleEmploiTokenRepository);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";
    final poleEmploiAccessToken = _poleEmploiTokenRepository.getPoleEmploiAccessToken();
    if (poleEmploiAccessToken != null) {
      data.headers["x-idp-token"] = "Bearer $poleEmploiAccessToken";
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
